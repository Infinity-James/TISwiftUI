//
//  Chapter1.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 03/12/2020.
//

import SwiftUI

//  MARK: Chapter 1
private struct Chapter1View: View {
	@State var counter = 0
	var body: some View {
		VStack {
			Button(action: { self.counter += 1 },
				   label: { Text("Tap me!")
					.padding()
					.background(Color(.tertiarySystemFill))
					.cornerRadius(5) })
			if counter > 0 {
				Text("You've tapped \(counter) times")
			} else { Text("You've not yet tapped") }
		}
		.frame(width: 200, height: 200)
		.border(Color.primary)
	}
}

//  MARK: Preview
struct Chapter1View_Previews: PreviewProvider {
	static var previews: some View {
		Chapter1View()
	}
}
