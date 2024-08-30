//
//  RaisedButtonStyle.swift
//
//
//  Created by Kunal Kumar on 2024-08-30.
//

import SwiftUI

struct RaisedButtonStyle: ButtonStyle {
    var baseColor: Color  // Base color
    var backgroundColor: Color  // Background color with opacity
    var borderColor: Color  // Border color without opacity

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)  // Background color with opacity
            .clipShape(RoundedRectangle(cornerRadius: 16))  // Apply corner radius
            .overlay(
                RoundedRectangle(cornerRadius: 16)  // Border with same radius
                    .stroke(borderColor, lineWidth: 2)  // Border color and width
            )
            .shadow(color: baseColor.opacity(0.3), radius: 8, x: 0, y: 4)  // Shadow to create raised effect
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)  // Slight scale effect when pressed
            .animation(.spring(), value: configuration.isPressed)  // Smooth animation on press
    }
}

extension Button {
    func raisedButtonStyle(baseColor: Color = Color.red) -> some View {
        let backgroundColorWithOpacity = baseColor.opacity(0.4)
        let borderColorWithoutOpacity = baseColor

        return self.buttonStyle(RaisedButtonStyle(baseColor: baseColor,
                                                  backgroundColor: backgroundColorWithOpacity,
                                                  borderColor: borderColorWithoutOpacity))
    }
}
