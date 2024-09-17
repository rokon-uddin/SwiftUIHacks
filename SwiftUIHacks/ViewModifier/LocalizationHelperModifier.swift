//
//  LocalizationHelperModifier.swift
//  SwiftUIHacks
//
//  Created by Mohammed Rokon Uddin on 9/17/24.
//

import SwiftUI

struct LocalizationHelperModifier: ViewModifier {
  @State private var nonLocalizedStrings: [String] = []

  func body(content: Content) -> some View {
    content
      .overlay(
        GeometryReader { _ in
          Color.clear
            .onAppear {
              inspectViewHierarchy(content)
            }
        }
      )
      .overlay(
        VStack(alignment: .leading) {
          Text("Non-localized strings:")
            .font(.caption)
            .bold()
          ForEach(nonLocalizedStrings, id: \.self) { string in
            Text(string)
              .font(.caption)
              .foregroundColor(.red)
          }
        }
        .padding(4)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(4)
        .padding(4),
        alignment: .bottomTrailing
      )
  }

  private func inspectViewHierarchy(_ view: Content) {
    let mirror = Mirror(reflecting: view)
    for child in mirror.children {
      if let textView = child.value as? Text {
        checkForLocalization(textView)
      }
    }
  }

  private func checkForLocalization(_ text: Text) {
    let mirror = Mirror(reflecting: text)
    for child in mirror.children {
      if let stringValue = child.value as? String, !stringValue.isEmpty {
        if !isLocalized(stringValue) {
          nonLocalizedStrings.append(stringValue)
        }
      }
    }
  }

  private func isLocalized(_ string: String) -> Bool {
    return NSLocalizedString(string, comment: "") != string
  }
}

extension View {
  func localizationHelper() -> some View {
    self.modifier(LocalizationHelperModifier())
  }
}
