//
//  Chapter5Exercise.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 07/01/2021.
//

import SwiftUI

//  MARK: Chapter 5 Exercise
public struct Chapter5Exercise: View {
	var cells = [
		[Text(""), Text("First").bold(), Text("Second").bold(), Text("Unread").bold()],
		[Text("Philosopher").bold(), Text("David Deutsch"), Text("Sam Harris"), Text("Hannah Arendt")],
		[Text("Economist").bold(), Text("Thomas Sowell"), Text("Adam Smith"), Text("Milton Friedman")]
	]
    public var body: some View {
        Table(cells: cells)
			.padding()
    }
}

//  MARK: Table
private struct Table<Content: View>: View {
	var cells: [[Content]]
    @State var selection: (row: Int, column: Int)?
	
	var body: some View {
		Preference(ColumnPreference.self) { columnWidths in
			VStack {
				ForEach(cells.indices) { row in
                    Preference(RowPreference.self) { rowHeight in
                        HStack(alignment: .top) {
                            ForEach(cells[row].indices) { column in
                                cell(forRow: row, column: column)
                                    .frame(width: columnWidths[column], height: rowHeight, alignment: .leading)
                                    .anchorPreference(key: SelectionPreference.self, value: .bounds) { anchor in
                                        selection?.row == row && selection?.column == column ? anchor : nil
                                    }
                                    .onTapGesture { withAnimation { selection = (row: row, column: column) } }
                            }
                        }
                    }
                }
            }
        }
        .overlayPreferenceValue(SelectionPreference.self) { anchor in
            GeometryReader { proxy in
                if anchor != nil {
                    Rectangle()
                        .stroke(Color.accentColor, lineWidth: 2)
                        .frame(width: proxy[anchor!].width, height: proxy[anchor!].height)
                        .offset(CGSize(width: proxy[anchor!].minX, height: proxy[anchor!].minY))
                }
            }
        }
    }
    
    func cell(forRow row: Int, column: Int) -> some View {
        cells[row][column]
            .fixedSize()
            .geometryPreference(ColumnPreference.self) { [column: $0.size.width] }
            .geometryPreference(RowPreference.self) { $0.size.height }
    }
}

private struct SelectionPreference: PreferenceKey {
    static let defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

private struct ColumnPreference: PreferenceKey {
    static let defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}

private struct RowPreference: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

public struct Preference<P: PreferenceKey, Content: View>: View where P.Value: Equatable {
    let content: (P.Value) -> Content
    @State private var value = P.defaultValue
    
    init(_ key: P.Type, @ViewBuilder content: @escaping (P.Value) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(value)
            .onPreferenceChange(P.self) { value = $0 }
    }
}

public extension View {
    func geometryPreference<P: PreferenceKey>(_ key: P.Type, value: @escaping (GeometryProxy) -> P.Value) -> some View {
        overlay(GeometryReader { Color.clear.preference(key: P.self, value: value($0)) })
    }
}

//  MARK: Previews
internal struct Chapter5Exercise_Previews: PreviewProvider {
    static var previews: some View {
        Chapter5Exercise()
    }
}
