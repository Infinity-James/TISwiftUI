//
//  Chapter4Exercise.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 02/01/2021.
//

import SwiftUI

//  MARK: Collapsible HStack
public struct Collapsible<Element: Identifiable, Content: View>: View {
	var data: [Element]
	var expanded = false
	var content: (Element) -> Content
	var offset: CGFloat = 4
	var alignment = VerticalAlignment.center

	public var body: some View {
		if expanded {
			HStack(alignment: alignment) {
				ForEach(data, content: content)
			}
		} else {
			ZStack(alignment: Alignment(horizontal: .center, vertical: alignment)) {
				ForEach(0..<data.count) { idx in
					content(data[idx])
						.offset(CGSize(width: offset * CGFloat(idx),
									   height: 0))
				}
			}
		}
	}
}
