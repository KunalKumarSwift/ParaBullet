import SwiftUI

struct AppBorderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appPrimary.opacity(0.5), lineWidth: 2)
            )
    }
}

extension View {
    /// Applies the standard application border style with rounded corners.
    func appBorder() -> some View {
        self.modifier(AppBorderStyle())
    }
}
