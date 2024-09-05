//
//  CardStyle.swift
//  
//
//  Created by Kunal Kumar on 2024-08-29.
//

import SwiftUI

struct CardStyle: ViewModifier {
    var baseColor: Color  // Base color
    var backgroundColor: Color  // Background color with opacity
    var borderColor: Color  // Border color without opacity

    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)  // Background color with opacity
            .clipShape(RoundedRectangle(cornerRadius: 16))  // Apply corner radius
            .overlay(
                RoundedRectangle(cornerRadius: 16)  // Border with same radius
                    .stroke(borderColor, lineWidth: 2)  // Border color and width
            )
            .shadow(radius: 16)
    }
}

extension View {
    func cardStyle(baseColor: Color = Color.red) -> some View {
        let backgroundColorWithOpacity = baseColor.opacity(0.4)
        let borderColorWithoutOpacity = baseColor

        return self.modifier(CardStyle(baseColor: baseColor,
                                       backgroundColor: backgroundColorWithOpacity,
                                       borderColor: borderColorWithoutOpacity))
    }
}
