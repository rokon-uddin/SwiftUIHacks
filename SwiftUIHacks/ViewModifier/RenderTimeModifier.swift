//
//  RenderTimeModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct RenderTimeModifier: ViewModifier {
  @State private var renderTime: TimeInterval = 0
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { _ in
          Color.clear
            .onAppear {
              let start = CACurrentMediaTime()
              DispatchQueue.main.async {
                let end = CACurrentMediaTime()
                self.renderTime = end - start
              }
            }
        }
      )
      .overlay(
        Text("Render Time: \(String(format: "%.2f", renderTime * 1000)) ms")
          .font(.caption)
          .padding(4)
          .background(Color.black.opacity(0.7))
          .foregroundColor(.white)
          .cornerRadius(4)
          .padding(4),
        alignment: .bottomLeading
      )
  }
}
extension View {
  func renderTimeTracker() -> some View {
    self.modifier(RenderTimeModifier())
  }
}
