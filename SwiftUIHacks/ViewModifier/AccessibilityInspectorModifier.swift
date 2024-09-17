//
//  AccessibilityInspectorModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct AccessibilityInspectorModifier: ViewModifier {
  @State private var accessibilityIssues: [String] = []

  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geometry in
          Color.clear
            .onAppear {
              checkAccessibility(for: geometry.size)
            }
        }
      )
      .overlay(
        VStack(alignment: .leading) {
          ForEach(accessibilityIssues, id: \.self) { issue in
            Text(issue)
              .font(.caption)
              .foregroundColor(.white)
              .padding(4)
              .background(Color.red.opacity(0.7))
              .cornerRadius(4)
          }
        }
        .padding(4),
        alignment: .topLeading
      )
  }

  private func checkAccessibility(for size: CGSize) {
    var issues: [String] = []

    // Check for small tap targets
    if size.width < 44 || size.height < 44 {
      issues.append("Small tap target")
    }

    // Add more checks here (e.g., contrast ratio, missing labels)

    self.accessibilityIssues = issues
  }
}

extension View {
  func accessibilityInspector() -> some View {
    self.modifier(AccessibilityInspectorModifier())
  }
}
