//
//  Chapter4.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 15/12/2020.
//

import SwiftUI

public struct Chapter4: View {
	public var body: some View {
		Text("Hello, World!")
	}
}

//  MARK: Measure Layout Behaviour
private struct MeasureBehavior<Content: View>: View {
	@State private var width: CGFloat = 100
	@State private var height: CGFloat = 100
	let content: Content
	
	var body: some View {
		VStack {
			content
				.border(Color.gray)
				.frame(width: width, height: height)
				.border(Color.black)
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
