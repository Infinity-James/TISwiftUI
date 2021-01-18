//
//  Chapter6Exercise.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 10/01/2021.
//

import SwiftUI

//  MARK: Chapter 6 Exercise
public struct Chapter6Exercise: View {
    @State private var taps = 0
    
    public var body: some View {
        Button("Bounce") {
            withAnimation(.linear(duration: 0.75)) { taps += 1 }
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.purple)
        .cornerRadius(8)
        .bounce(times: 3 * taps)
    }
}

//  MARK: Bounce
private struct BounceEffect: GeometryEffect {
    var times: CGFloat
    var amplitude: CGFloat
    
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: 0,
                              y: -abs(sin(times * .pi)) * amplitude)
        )
    }
}


private struct Bounce: AnimatableModifier {
    var times: CGFloat
    var amplitude: CGFloat
    
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }
    func body(content: Content) -> some View {
        content
            .offset(y: -abs(sin(times * .pi)) * amplitude)
    }
}

public extension View {
    func bounce(times: Int, amplitude: CGFloat = 30) -> some View {
        modifier(BounceEffect(times: CGFloat(times), amplitude: amplitude))
    }
}

//  MARK: Preview
internal struct Chapter6Exercise_Previews: PreviewProvider {
    static var previews: some View {
        Chapter6Exercise()
    }
}
