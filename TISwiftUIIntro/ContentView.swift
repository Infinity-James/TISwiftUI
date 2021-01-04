//
//  ContentView.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 28/11/2020.
//

import SwiftUI
public struct ContentView: View {
	public var body: some View {
		Chapter4()
	}
}
//  MARK: Convenience
public extension View {
	func debug() -> Self {
		print(Mirror(reflecting: self).subjectType)
		return self
	}
}

//  MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
