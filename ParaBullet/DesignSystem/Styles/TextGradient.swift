//
//  TextGradient.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-09.
//

import SwiftUI

struct TextGradient: ViewModifier {
    var colors: [Color]
    var startPoint: UnitPoint
    var endPoint: UnitPoint

    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
                .mask(content)
        )
    }
}

extension View {
    func textGradient(colors: [Color], startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) -> some View {
        self.modifier(TextGradient(colors: colors, startPoint: startPoint, endPoint: endPoint))
    }
}
