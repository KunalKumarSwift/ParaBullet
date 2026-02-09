//
//  HideKeyboard.swift
//  ParaBullet
//
//  Created by Kunal Kumar on 2023-09-13.
//


import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}

