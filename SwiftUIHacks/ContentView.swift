//
//  ContentView.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct ContentView: View {
  @State private var colorScheme: ColorScheme = .light
  var body: some View {
    VStack(alignment: .center) {
      Spacer()
        .frame(height: 100)
      VStack {
        Spacer()
        Rectangle()
          .fill(Color.random().gradient)
          .frame(maxWidth: .infinity)
          .frame(height: 100)
          .displaySize()

        Text("Hello, world!")
          .font(.largeTitle)
          .localizationHelper()

        Text("How are you?")
          .font(.largeTitle)
          .localizationHelper()

        Image(systemName: "star.fill")
          .font(.system(size: 200))
          .foregroundStyle(.yellow)
          .renderTimeTracker()
          .accessibilityInspector()

        Button("Tap Me") {

        }
        .accessibilityInspector()
        Spacer()
      }
      .performanceMetrics()
      .colorSchemeSwitcher(colorScheme: $colorScheme)

      Spacer()
    }
    .navigationTitle("SwiftUI Hacks")
    .navigationBarTitleDisplayMode(.inline)
    .layoutGuides(baseline: false)
    .ignoresSafeArea()
  }
}

#Preview {
  NavigationStack {
    ContentView()
  }
}
