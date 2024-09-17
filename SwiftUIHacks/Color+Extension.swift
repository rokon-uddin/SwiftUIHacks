//
//  Color+Extension.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

extension Color {
  static func random(randomOpacity: Bool = false) -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      opacity: randomOpacity ? .random(in: 0...1) : 1
    )
  }
}
