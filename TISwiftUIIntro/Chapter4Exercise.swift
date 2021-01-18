//
//  Chapter4Exercise.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 02/01/2021.
//

import SwiftUI

//  MARK: Chapter 4 Exercise Part 2
public struct Chapter4ExercisePart2: View {
	@State private var count: Int = 0
	public var body: some View {
		VStack {
			Text("Part 2")
				.foregroundColor(.white)
				.padding()
				.background(RoundedRectangle(cornerRadius: 4)
								.fill(Color.orange))
				.badge(count, alignment: .bottomLeading)
			Stepper("Count", value: $count.animation())
		}
		.badgeColor(.accentColor)
		.padding()
	}
}

//  MARK: Badge
public extension View {
	func badge(_ count: Int, alignment: Alignment = .topTrailing) -> some View {
		overlay(
			ZStack {
				if count != 0 {
					Badge(count: count)
						.animation(nil)
						.transition(.scale)
				}
			}
			.alignmentGuide(alignment.horizontal) { $0[HorizontalAlignment.center] }
			.alignmentGuide(alignment.vertical) { $0[VerticalAlignment.center] },
			alignment: alignment)
	}
	
	func badgeColor(_ color: Color) -> some View {
		environment(\.badgeColor, color)
	}
}

private struct Badge: View {
	let count: Int
	@Environment(\.badgeColor) var color
	
	var body: some View {
		Circle()
			.fill(color ?? Color.red)
			.frame(width: 24, height: 24)
			.overlay(Text("\(count)")
						.foregroundColor(Color.white)
						.font(.footnote))
	}
}

private struct BadgeColorKey: EnvironmentKey {
	static let defaultValue: Color? = nil
}

private extension EnvironmentValues {
	var badgeColor: Color? {
		get { self[BadgeColorKey.self] }
		set { self[BadgeColorKey.self] = newValue }
	}
}

//  MARK: Chapter 4 Exercise Part 1
public struct Chapter4ExercisePart1: View {
	@State private var collapsed = true
	private let data: [(Color, CGFloat)] = [
		(.red, 100),
		(.green, 60),
		(.blue, 80)
	]
	public var body: some View {
		VStack {
			Toggle(isOn: $collapsed.animation(), label: { Text("Collapsed") })
			CollapsibleHStack(data: data, collapsed: $collapsed, collapsedWidth: 25, alignment: .bottom, spacing: 16) { (color, dimension) in
				color
					.frame(width: dimension, height: dimension)
			}
		}
		.padding()
	}
}

//  MARK: Int + Identifiable
extension Int: Identifiable { public var id: Int { self } }

//  MARK: Collapsible HStack
public struct CollapsibleHStack<Element, Content: View>: View {
	var data: [Element]
	@Binding var collapsed: Bool
	var collapsedWidth: CGFloat = 10
	var alignment: VerticalAlignment = .center
	var spacing: CGFloat?
	var content: (Element) -> Content
	
	public var body: some View {
		HStack(alignment: alignment, spacing: collapsed ? 0 : spacing) {
			ForEach(data.indices) { idx in
				content(data[idx])
					.frame(width: (collapsed && idx < data.endIndex - 1) ? collapsedWidth : nil,
						   alignment: .leading)
			}
		}
	}
}

//  MARK: Preview
internal struct Chapter4Exercise_Previews: PreviewProvider {
	static var previews: some View {
		Chapter4ExercisePart2()
	}
}
