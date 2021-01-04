//
//  Measure.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 28/12/2020.
//

import SwiftUI

//  MARK: Measured
extension View {
	func measuredWidth(_ color: Color) -> some View {
		overlay(GeometryReader { p in
			HStack(spacing: 2) {
				HorizontalArrow()
				Text("\(p.size.width, specifier: "%.0f")")
					.font(.system(size: 14))
					.bold()
					.foregroundColor(color)
					.fixedSize()
					.frame(maxHeight: .infinity)
				HorizontalArrow()
					.scaleEffect(-1, anchor: .center)
			}
		})
	}

	func measuredHeight(_ color: Color) -> some View {
		overlay(GeometryReader { p in
			VStack(spacing: 2) {
				VerticalArrow()
				Text("\(p.size.height, specifier: "%.0f")")
					.font(.system(size: 14))
					.bold()
					.foregroundColor(color)
					.fixedSize()
					.frame(maxWidth: .infinity)
				VerticalArrow()
					.scaleEffect(-1, anchor: .center)
			}
		})
	}

	var measuredWidth: some View {
		measuredWidth(.white)
	}

	var measuredHeight: some View {
		measuredHeight(.white)
	}

	var measuredWidthBelow: some View {
		self
			.padding(.bottom, 25)
			.overlay(Color.clear
						.frame(height: 25)
						.measuredWidth(.black),
					 alignment: .bottom)
	}

	var measuredHeightLeft: some View {
		self
			.padding(.leading, 25)
			.overlay(Color.clear
						.frame(width: 25)
						.measuredHeight(.black),
					 alignment: .leading)
	}
}

struct HorizontalArrowShape: Shape {
	func path(in rect: CGRect) -> Path {
		Path { p in
			let x = rect.minX + 2
			let size: CGFloat = 5
			p.move(to: CGPoint(x: x, y: rect.midY))
			p.addLine(to: CGPoint(x: x + size, y: rect.midY - size))
			p.move(to: CGPoint(x: x, y: rect.midY))
			p.addLine(to: CGPoint(x: x + size, y: rect.midY + size))
			p.move(to: CGPoint(x: x, y: rect.midY))
			p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
		}
	}
}

struct HorizontalArrow: View {
	var body: some View {
		HorizontalArrowShape()
			.stroke(lineWidth: 1)
			.foregroundColor(Color(red: 9/255.0, green: 73/255.0, blue: 109/255.0))
	}
}

struct VerticalArrowShape: Shape {
	func path(in rect: CGRect) -> Path {
		Path { p in
			let y = rect.minY + 2
			let size: CGFloat = 5
			p.move(to: CGPoint(x: rect.midX, y: y))
			p.addLine(to: CGPoint(x: rect.midX - size, y: y + size))
			p.move(to: CGPoint(x: rect.midX, y: y))
			p.addLine(to: CGPoint(x: rect.midX + size, y: y + size))
			p.move(to: CGPoint(x: rect.midX, y: y))
			p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
		}
	}
}

struct VerticalArrow: View {
	var body: some View {
		VerticalArrowShape()
			.stroke(lineWidth: 1)
			.foregroundColor(Color(red: 9/255.0, green: 73/255.0, blue: 109/255.0))
	}
}
