//
//  ColorSchemeSwitcherModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct ColorSchemeSwitcherModifier: ViewModifier {
  @Binding var colorScheme: ColorScheme

  func body(content: Content) -> some View {
    content
      .preferredColorScheme(colorScheme)
      .overlay(
        Button(action: {
          colorScheme = colorScheme == .light ? .dark : .light
        }) {
          Image(systemName: colorScheme == .light ? "moon.fill" : "sun.max.fill")
            .foregroundColor(colorScheme == .light ? .black : .white)
            .padding(8)
            .background(colorScheme == .light ? Color.white : Color.black)
            .clipShape(Circle())
        }
        .padding(8),
        alignment: .topTrailing
      )
  }
}

extension View {
  func colorSchemeSwitcher(colorScheme: Binding<ColorScheme>) -> some View {
    self.modifier(ColorSchemeSwitcherModifier(colorScheme: colorScheme))
  }
}
