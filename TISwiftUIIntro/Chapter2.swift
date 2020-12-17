//
//  Chapter2.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 03/12/2020.
//

import SwiftUI

//  MARK: ObservableObject
public struct Chapter2TimerView: View {
	public var body: some View {
		NavigationView {
			NavigationLink(
				destination: TimerView(),
				label: { Text("Go to timer.") })
		}
	}
}

private struct TimerView: View {
	@ObservedObject private var date = CurrentTime()
	
	var body: some View {
		Text("\(date.now)")
			.onAppear { date.start() }
			.onDisappear { date.stop() }
	}
}

private final class CurrentTime: ObservableObject {
	//	`objectWillChange` value inferred from this Published property
	@Published var now = Date()
	let interval: TimeInterval = 1
	private var timer: Timer?
	
	func start() {
		guard timer == nil else { return }
		now = Date()
		timer = .scheduledTimer(withTimeInterval: interval, repeats: true) { [unowned self] _ in
			self.now = Date()
		}
	}
	
	func stop() {
		timer?.invalidate()
		timer = nil
	}
}

//  MARK: @State and @Binding
public struct Chapter2KnobView: View {
	@State var volume: Double = 0.5
	public var body: some View {
		VStack {
			Knob(value: $volume)
				.frame(width: 100, height: 100)
			Slider(value: $volume, in: 0...1)
			
		}
	}
}

private struct Knob: View {
	@Binding var value: Double
	var body: some View {
		KnobShape()
			.fill(Color.gray)
			.rotationEffect(.degrees(value * 330))
			.onTapGesture {
				value = value < 0.5 ? 1 : 0
			}
	}
}

private struct KnobInelegant: View {
	var value: Double
	var valueChanged: (Double) -> ()
	var body: some View {
		KnobShape()
			.fill(Color.gray)
			.rotationEffect(.degrees(value * 330))
			.onTapGesture {
				valueChanged(value < 0.5 ? 1 : 0)
			}
	}
}

//  MARK: Performance
/**
SwiftUI has three different mechanism for building a view tree with dynamic parts:
1. if/else conditions in view builders
These branches are encoded into the view tree (as _ConditionalContent)

2. ForEach
The number of views can change, but must be of the same type.
Each element must be identifiable which allows for the diff.

3. AnyView
Allows for type erasure; efficient diffing is destroyed.
*/


private struct OptimisedView: View {
	@State var counter = 0
	///	Only the LabelView will be rebuilt and diffed because only it cares about the State.
	///	SwiftUI knows that OptimisedView diesb't use the counter state when rendering the body, but LabelView does.
	var body: some View {
		VStack {
			Button("Tap Me") { self.counter += 1 }
			LabelView(number: $counter)
		}
	}
}

private struct LabelView: View {
	@Binding var number: Int
	var body: some View {
		Group { if number > 0 { Text("You've tapped \(number) times") } }
	}
}

private struct DumbView: View {
	@State var counter = 0
	///	VStack<TupleView<(Button<Text>, Text>)>>
	///	Structure of the view tree is always the same - great for performant diffing.
	var body: some View {
		VStack {
			Button("Tap Me") { self.counter += 1 }
			if counter > 0 { Text("You've tapped \(counter) times") }
		}
	}
}

//  MARK: Preview
struct Chapter2View_Previews: PreviewProvider {
	static var previews: some View {
		Chapter2TimerView()
	}
}
