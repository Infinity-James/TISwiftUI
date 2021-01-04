//
//  Chapter4.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 15/12/2020.
//

import SwiftUI

//  MARK: Chapter 4
public struct Chapter4: View {
	private var content: some View {
		ButtonStyling()
	}

	public var body: some View {
		MeasureBehavior(content: content)
	}
}

//  MARK: Styling
private struct ButtonStyling: View {
	var body: some View {
		HStack {
			Button("Press Me") { }
			Button("No, Press Me") { }
			Button("No, Me!!") { }
		}
		.buttonStyle(CircleStyle())
	}
}

private struct CircleStyle: ButtonStyle {
	var foreground = Color.white
	var background = Color.blue

	func makeBody(configuration: Configuration) -> some View {
		Circle()
			.fill(background.opacity(configuration.isPressed ? 0.8 : 1))
			.overlay(Circle().strokeBorder(foreground).padding(3))
			.overlay(configuration.label.foregroundColor(foreground))
			.frame(width: 75, height: 75)
	}
}

//  MARK: Grids
private struct Grids: View {
	var body: some View {
		LazyVGrid(columns: [GridItem(.flexible(minimum: 60), spacing: 0),
							GridItem(.adaptive(minimum: 40), spacing: 0),
							GridItem(.flexible(minimum: 150))],
				  spacing: 0) {
			ForEach(0..<8) { _ in
				Color.orange
					.border(Color.gray, width: 4)
					.measuredWidth
					.frame(height: 40)
			}
		}
	}
}

//  MARK: Alignment
private struct StackAlignment: View {
	var body: some View {
		HStack(alignment: .customCentre) {
			Color.orange
				.frame(width: 50, height: 50)
			Color.gray
				.frame(width: 30, height: 30)
			Color.yellow
				.frame(width: 40, height: 40)
				.alignmentGuide(.customCentre) { $0[.customCentre] - 20 }
		}
	}
}

private enum CustomCentre: AlignmentID {
	static func defaultValue(in context: ViewDimensions) -> CGFloat {
		context.height / 2
	}
}

private extension VerticalAlignment {
	static let customCentre: VerticalAlignment = VerticalAlignment(CustomCentre.self)
}

//  MARK: Layout Priority
private struct LayoutPriority: View {
	var body: some View {
		VStack {
			HStack(spacing: 0) {
				Text("/Users/James/Developer/FIXR/Client/")
					.truncationMode(.middle)
					.lineLimit(1)
				Text("secrets.md")
					.layoutPriority(1)

			}
			HStack(spacing: 0) {
				Color.red
					.frame(minWidth: 50)
				Color.blue
					.frame(maxWidth: 100)
					.layoutPriority(1)
			}
		}
	}
}

//  MARK: Stacks
private struct Stacks: View {
	var body: some View {
		HStack {
			Text("If You Know You Know")
			Color.green.frame(minWidth: 150)
		}
	}
}

//  MARK: Clipping
private struct Clipping: View {
	var body: some View {
		Rectangle()
			.rotation(.degrees(45))
			.fill(Color.pink)
			.clipped()
	}
}

//  MARK: Matched Geometry
private struct MatchedGeometryEffect: View {
	@Namespace var ns

	var body: some View {
		HStack(spacing: 0) {
			Rectangle()
				.fill(Color.black)
				.frame(width: 100, height: 100)
				.matchedGeometryEffect(id: "ID", in: ns, isSource: true)
			Circle()
				.fill(Color.gray)
				.matchedGeometryEffect(id: "ID", in: ns, isSource: false)
				.border(Color.red, width: 6)
		}
		.frame(width: 300, height: 100)
		.border(Color.black)
	}
}

//	MARK: Triangle
private struct Triangle: Shape {
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
			path.addLines([
				CGPoint(x: rect.maxX, y: rect.maxY),
				CGPoint(x: rect.minX, y: rect.maxY),
				CGPoint(x: rect.midX, y: rect.minY)
			])
		}
	}
}

//  MARK: Measure Layout Behaviour
private struct MeasureBehavior<Content: View>: View {
	@State private var width: CGFloat = 250
	@State private var height: CGFloat = 200
	let content: Content

	var body: some View {
		VStack {
			content
				.border(Color.gray)
				.frame(width: width, height: height)
				.border(Color.black)
				.measuredWidthBelow
				.measuredHeightLeft

			HStack {
				Text("Width: ")
				Slider(value: $width, in: 0...500)
			}

			HStack {
				Text("Height: ")
				Slider(value: $height, in: 0...500)
			}
		}
	}
}

//  MARK: Preview
internal struct Chapter4_Previews: PreviewProvider {
	static var previews: some View {
		Chapter4()
	}
}
