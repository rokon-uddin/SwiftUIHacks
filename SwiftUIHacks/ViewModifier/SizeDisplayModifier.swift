//
//  SizeDisplayModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct SizeDisplayModifier: ViewModifier {
  @State private var size: CGSize = .zero

  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geometry in
          Color.clear
            .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
      )
      .onPreferenceChange(SizePreferenceKey.self) { newSize in
        self.size = newSize
      }
      .overlay(
        Text("W: \(Int(size.width)) H: \(Int(size.height))")
          .font(.caption)
          .padding(4)
          .background(Color.black.opacity(0.7))
          .foregroundColor(.white)
          .cornerRadius(4)
          .padding(4),
        alignment: .topLeading
      )
  }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

extension View {
  func displaySize() -> some View {
    self.modifier(SizeDisplayModifier())
  }
}
