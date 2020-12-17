//
//  Chapter3Exercise.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 14/12/2020.
//

import SwiftUI

//  MARK: Knob
private struct Knob: View {
	@Binding var value: Double
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.knobPointerColor) private var color
	@Environment(\.knobPointerSize) private var envPointerSize
	var pointerSize: CGFloat?
	
	var body: some View {
		KnobShape(pointerSize: pointerSize ?? envPointerSize)
			.fill(color ?? (colorScheme == .dark ? Color.white : Color.gray))
			.rotationEffect(.degrees(value * 330))
			.onTapGesture {
				value = value < 0.5 ? 1 : 0
			}
	}
}

//  MARK: Knob Color
private extension View {
	func knobPointerColor(_ color: Color) -> some View {
		environment(\.knobPointerColor, color)
	}
}

private struct PointerColorKey: EnvironmentKey {
	static let defaultValue: Color? = nil
}

private extension EnvironmentValues {
	var knobPointerColor: Color? {
		get { self[PointerColorKey.self] }
		set { self[PointerColorKey.self] = newValue }
	}
}

//  MARK: Knob Pointer Size
private extension View {
	func knobPointerSize(_ size: CGFloat) -> some View {
		environment(\.knobPointerSize, size)
	}
}

private struct PointerSizeKey: EnvironmentKey {
	static let defaultValue: CGFloat = 0.1
}

private extension EnvironmentValues {
	var knobPointerSize: CGFloat {
		get { self[PointerSizeKey.self] }
		set { self[PointerSizeKey.self] = newValue }
	}
}

//  MARK: Chapter 3 Exercise
public struct Chapter3Exercise: View {
	@State private var color: CGColor = UIColor.systemPurple.cgColor
	@State private var value: Double = 0
    public var body: some View {
		VStack {
			Knob(value: $value)
				.frame(width: 150, height: 150)
			Slider(value: $value, in: 0...1)
			ColorPicker("Knob Color", selection: $color)
		}
		.environment(\.knobPointerColor, Color(color))
    }
}

//  MARK: Preview
internal struct Chapter3Exercise_Previews: PreviewProvider {
    static var previews: some View {
        Chapter3Exercise()
    }
}
