//
//  ContentView.swift
//  nexatel
//
//  Created by Sabuj on 24/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Gradient Text")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundStyle(
                    .linearGradient(
                        colors: [.yellow, .blue],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .accessibilityLabel("Gradient title")
                .accessibilityAddTraits(.isHeader)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
