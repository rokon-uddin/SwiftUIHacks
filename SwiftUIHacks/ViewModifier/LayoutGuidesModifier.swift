//
//  LayoutGuidesModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct LayoutGuidesModifier: ViewModifier {
  let grid: Bool
  let baseline: Bool

  func body(content: Content) -> some View {
    content
      .overlay(
        GeometryReader { geometry in
          ZStack {
            if grid {
              gridOverlay(for: geometry.size)
            }
            if baseline {
              baselineOverlay(for: geometry.size)
            }
          }
        }
      )
  }

  private func gridOverlay(for size: CGSize) -> some View {
    let gridSpacing: CGFloat = 20
    return ZStack {
      ForEach(0..<Int(size.width / gridSpacing), id: \.self) { i in
        Path { path in
          let x = CGFloat(i) * gridSpacing
          path.move(to: CGPoint(x: x, y: 0))
          path.addLine(to: CGPoint(x: x, y: size.height))
        }
        .stroke(Color.blue.opacity(0.3), lineWidth: 0.5)
      }
      ForEach(0..<Int(size.height / gridSpacing), id: \.self) { i in
        Path { path in
          let y = CGFloat(i) * gridSpacing
          path.move(to: CGPoint(x: 0, y: y))
          path.addLine(to: CGPoint(x: size.width, y: y))
        }
        .stroke(Color.blue.opacity(0.3), lineWidth: 0.5)
      }
    }
  }

  private func baselineOverlay(for size: CGSize) -> some View {
    let baselineSpacing: CGFloat = 8
    return VStack(spacing: baselineSpacing) {
      ForEach(0..<Int(size.height / baselineSpacing), id: \.self) { _ in
        Divider()
          .background(Color.red.opacity(0.3))
      }
    }
  }
}

extension View {
  func layoutGuides(grid: Bool = true, baseline: Bool = true) -> some View {
    self.modifier(LayoutGuidesModifier(grid: grid, baseline: baseline))
  }
}
