//
//  Chapter5.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 05/01/2021.
//

import SwiftUI

//  MARK: Chapter 5
public struct Chapter5: View {
    public var body: some View {
		UsingFlexiStack()
    }
}

//  MARK: Flexible Stack
private struct UsingFlexiStack: View {
	let colors: [(Color, CGFloat)] = [(.orange, 50), (.purple, 30), (.yellow, 75)]
	@State private var horizontal = true
	
	var body: some View {
		VStack {
			Toggle(isOn: $horizontal, label: { Text("Horizontal") })
			FlexiStack(elements: colors, axis: horizontal ? .horizontal : .vertical) { item in
				Rectangle()
					.fill(item.0)
					.frame(width: item.1, height: item.1)
			}
			.border(Color.gray)
		}
	}
}

public struct FlexiStack<Element, Content: View>: View {
	var elements: [Element]
	var spacing: CGFloat = 8
	var axis: Axis = .horizontal
	var alignment: Alignment = .topLeading
	var content: (Element) -> Content
	@State private var offsets: [CGPoint] = []
	
	public var body: some View {
		ZStack(alignment: alignment) {
			ForEach(elements.indices) { idx in
				content(elements[idx])
					.modifier(CollectSize(index: idx))
					.alignmentGuide(alignment.horizontal) { dimension in
						axis == .horizontal ? -offset(at: idx).x : dimension[alignment.horizontal]
					}
					.alignmentGuide(alignment.vertical) { dimension in
						axis == .vertical ? -offset(at: idx).y : dimension[alignment.vertical]
					}
			}
		}
		.onPreferenceChange(CollectSizePreference.self, perform: computeOffsets)
	}
	
	private func computeOffsets(_ sizes: [Int: CGSize]) {
		guard !sizes.isEmpty else { return }
		
		var offsets: [CGPoint] = [.zero]
		for idx in 0..<elements.count {
			guard let size = sizes[idx] else { fatalError() }
			var newPoint = offsets.last!
			newPoint.x += size.width + spacing
			newPoint.y += size.height + spacing
			offsets.append(newPoint)
		}
		self.offsets = offsets
	}
	
	private func offset(at index: Int) -> CGPoint {
		index < offsets.endIndex ? offsets[index] : .zero
	}
}

private struct CollectSizePreference: PreferenceKey {
	static let defaultValue: [Int: CGSize] = [:]
	static func reduce(value: inout [Int : CGSize], nextValue: () -> [Int : CGSize]) {
		value.merge(nextValue(), uniquingKeysWith: { $1 })
	}
}

private struct CollectSize: ViewModifier {
	var index: Int
	func body(content: Content) -> some View {
		content
			.background(
				GeometryReader { proxy in
					Color.clear
						.preference(key: CollectSizePreference.self, value: [index: proxy.size])
				}
			)
	}
}

//  MARK: Matched Tab Bar
private struct MatchedTabBar: View {
	private let tabs: [Text] = [
		Text("Ethics"),
		Text("Life"),
		Text("Politics")
	]
	@State private(set) var selectedTabIndex = 0
	@Namespace private var ns
	
	var body: some View {
		HStack {
			ForEach(tabs.indices) { tabIndex in
				Button(action: { withAnimation { selectedTabIndex = tabIndex } },
					   label: { tabs[tabIndex] })
					.matchedGeometryEffect(id: tabIndex, in: ns)
			}
		}
		.overlay(
			Rectangle()
				.fill(Color.accentColor)
				.frame(height: 2)
				.matchedGeometryEffect(id: selectedTabIndex, in: ns, isSource: false)
		)
	}
}

//  MARK: Anchored Tab Bar
private struct BoundsKey: PreferenceKey {
	static var defaultValue: Anchor<CGRect>? = nil
	static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
		value = value ?? nextValue()
	}
}

private struct AnchoredTabBar: View {
	private let tabs: [Text] = [
		Text("Ethics"),
		Text("Life"),
		Text("Politics")
	]
	@State private(set) var selectedTabIndex = 0
	
	var body: some View {
		HStack {
			ForEach(tabs.indices) { tabIndex in
				Button(action: { selectedTabIndex = tabIndex }, label: { tabs[tabIndex] })
					.anchorPreference(key: BoundsKey.self, value: .bounds) { anchor in
						selectedTabIndex == tabIndex ? anchor : nil
					}
			}
		}
		.overlayPreferenceValue(BoundsKey.self) { anchor in
			GeometryReader { proxy in
				Rectangle()
					.fill(Color.accentColor)
					.frame(width: proxy[anchor!].width, height: 2)
					.offset(x: proxy[anchor!].minX)
					.frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomLeading)
					.animation(.default)
			}
		}
	}
}

//  MARK: Circle Text
private struct CircleText: View {
	let text: String
	let color: Color
	@State private var size: CGSize?
	private var dimension: CGFloat? { size.flatMap { max($0.width, $0.height) } }
	
	var body: some View {
		Text(text)
			.padding()
			.background(GeometryReader { proxy in
				Color.clear.preference(key: SizeKey.self, value: proxy.size)
			})
			.onPreferenceChange(SizeKey.self) { size = $0 }
			.frame(width: dimension, height: dimension)
			.background(Circle().fill(color))
	}
}

private struct SizeKey: PreferenceKey {
	static let defaultValue: CGSize? = nil
	static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
		value = value ?? nextValue()
	}
}

//  MARK: Chapter 5 Previews
internal struct Chapter5_Previews: PreviewProvider {
    static var previews: some View {
        Chapter5()
    }
}
