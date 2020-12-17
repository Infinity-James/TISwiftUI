//
//  Chapter3.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 08/12/2020.
//

import SwiftUI

//  MARK: Preferences
/**
Preferences allow from values to passed up the tree, from child views to superviews.
*/
public struct PreferenceExampleView: View {
	public var body: some View {
		CustomNavigationView(content: ZStack {
			Color.blue
			VStack {
				Spacer()
				Text("The Myth of Sisyphus")
				Spacer()
				Text("by Albert Camus")
				Color.clear.frame(height: 100)
			}
			.foregroundColor(.white)
			.font(Font.system(size: 30, weight: .heavy, design: .serif))
		}
		.customNevigationTitle("The Philosophy of Suicide"))
	}
}

private struct CustomNavigationView<Content: View>: View {
	let content: Content
	@State private var title: String?
	var body: some View {
		VStack {
			Text(title ?? "")
				.font(.largeTitle)
			Spacer()
			content
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.onPreferenceChange(NavigationTitleKey.self) { title = $0 }
			Spacer()
		}
	}
}

private extension View {
	func customNevigationTitle(_ title: String) -> some View {
		preference(key: NavigationTitleKey.self, value: title)
	}
}

private struct NavigationTitleKey: PreferenceKey {
	static var defaultValue: String? = nil
	static func reduce(value: inout String?, nextValue: () -> String?) {
		value = value ?? nextValue()
	}
}

//  MARK: Dependency Injection
private struct ParentView: View {
	var body: some View {
		NavigationView {
			DependantView()
				.environmentObject(DatabaseConnection())
		}
	}
}

/**
When passing by reference type one should use @EnvironmentObject.
*/
private struct DependantView: View {
	@EnvironmentObject var connection: DatabaseConnection
	
	var body: some View {
		VStack {
			if connection.isConnected {
				Text("Connected")
			}
		}
	}
}

private final class DatabaseConnection: ObservableObject {
	@Published var isConnected: Bool = false
}

//  MARK: Environmental Knob Configuration
public struct Chapter3Knobs: View {
	@State private var volume: Double = 0.5
	@State private var balance: Double = 0.5
	
	public var body: some View {
		VStack {
			Knob(value: $volume)
				.frame(width: 150, height: 150)
			Knob(value: $balance)
				.frame(width: 150, height: 150)
			Slider(value: $volume, in: 0...1)
			Slider(value: $balance, in: 0...1)
		}
		.knobPointerSize(0.3)
	}
}

private struct Knob: View {
	@Binding var value: Double
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.knobPointerSize) private var envPointerSize
	var pointerSize: CGFloat?
	
	var body: some View {
		KnobShape(pointerSize: pointerSize ?? envPointerSize)
			.fill(colorScheme == .dark ? Color.white : Color.gray)
			.rotationEffect(.degrees(value * 330))
			.onTapGesture {
				value = value < 0.5 ? 1 : 0
			}
	}
}

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

//  MARK: Environment
/**
A value can be set on the environment which is then propagated down the tree to views that are interested.
*/
private struct EnvironmentFunctions: View {
	var body: some View {
		VStack {
			//	as a sibling, this is not modified
			Text("Evolution denialists.")
				.transformEnvironment(\.font) { dump($0) }
			//	children are modified
			HStack {
				Text("Yes, culture is important.")
				Text("No, humans do not start as blank states, moulded by our environment.")
			}
			.font(.headline)
			//	same as:
			//	.environment(\.font, Font.headline)
		}
	}
}

//  MARK: Preview
internal struct Chapter3_Previews: PreviewProvider {
	static var previews: some View {
		PreferenceExampleView()
	}
}
