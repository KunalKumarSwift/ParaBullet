//
//  PickerStyleViewModifier.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-12.
//

import SwiftUI

struct PickerStyleModifier: ViewModifier {
    let geometry: GeometryProxy
    let widthThreshold: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        if geometry.size.width <= widthThreshold {
            content.pickerStyle(MenuPickerStyle())
        } else {
            content.pickerStyle(SegmentedPickerStyle())
        }
    }
}

extension View {
    func adaptablePickerStyle(geometry: GeometryProxy, widthThreshold: CGFloat) -> some View {
        self.modifier(PickerStyleModifier(geometry: geometry, widthThreshold: widthThreshold))
    }
}
