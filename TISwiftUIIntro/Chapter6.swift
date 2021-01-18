//
//  Chapter6.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 08/01/2021.
//

import SwiftUI

//  MARK: Chapter 6
public struct Chapter6: View {
    public var body: some View {
        ShakingButton()
    }
}

//  MARK: Custom Transitions
private struct Blur: ViewModifier {
    var active: Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: active ? 50 : 0)
            .opacity(active ? 0 : 1)
    }
}

public extension AnyTransition {
    static var blur: AnyTransition { .modifier(active: Blur(active: true), identity: Blur(active: false)) }
}

//  MARK: Shake
private struct ShakingButton: View {
    @State private var taps: Int = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.5)) {
                taps += 1
            }
        },
               label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange)
                    .frame(width: 100, height: 100)
                    .overlay(Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .foregroundColor(.white)
                                .padding())
               })
        .shake(times: taps * 3)
    }
}

public extension View {
    func shake(times: Int) -> some View {
        modifier(Shake(times: times))
    }
}

public struct Shake: AnimatableModifier {
    private var times: CGFloat = 0
    private let amplitude: CGFloat = 10
    public var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }
    
    init(times: Int) { self.times = CGFloat(times) }
    
    public func body(content: Content) -> some View {
        content
            .offset(x: sin(times * .pi * 2) * amplitude)
    }
}

//  MARK: Traced Loading Indicator
private struct TracedLoadingIndicator: View {
    @State private var appeared = false
    private let animation = Animation
        .linear(duration: 1)
        .repeatForever(autoreverses: false)
    
    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .frame(width: 5, height: 5)
            .offset(y: -50)
            .rotationEffect(appeared ? .degrees(360) : .zero)
            .onAppear { withAnimation(animation) { appeared = true } }
    }
}

//  MARK: Matched Geometry Effect
private struct MatchedAnimation: View {
    @State private var showRectangle = false
    @Namespace private var ns
    
    var body: some View {
        VStack {
            HStack {
                if showRectangle {
                    Rectangle()
                        .fill(Color.orange)
                        .matchedGeometryEffect(id: "1", in: ns)
                        .frame(width: 200, height: 200)
                }
                Spacer()
                    if !showRectangle {
                        Circle()
                            .fill(Color.purple)
                            .matchedGeometryEffect(id: "1", in: ns)
                            .frame(width: 150, height: 150)
                    }
            }
            .border(Color.gray)
            .frame(width: 300, height: 200)
            Toggle("", isOn: $showRectangle)
        }
        .animation(.default)
    }
}

//  MARK: Transition
private struct Transition: View {
    @State private var visible = false
    
    var body: some View {
        VStack {
            Button("Toggle") { visible.toggle() }
            if visible {
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 100, height: 100)
                    .transition(.slide)
                    .animation(.default)
            }
        }
    }
}

//  MARK: Loading Indicator
private struct LoadingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        Image(systemName: "rays")
            .rotationEffect(animating ? .degrees(360) : .zero)
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            .onAppear { animating = true }
    }
}

//  MAR: Implicit Animation
private struct Implicit: View {
    @State var selected = false
    
    var body: some View {
        Button(action: { selected.toggle() }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(selected ? Color.orange : .purple)
                .frame(width: selected ? 100 : 50, height: selected ? 100 : 50)
        }
        .animation(.default)
    }
}

//  MARK: Chapter 6 Previews
internal struct Chapter6_Previews: PreviewProvider {
    static var previews: some View {
        Chapter6()
    }
}
