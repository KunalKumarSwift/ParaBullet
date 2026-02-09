import SwiftUI

struct AppPageStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                content
                    .frame(maxWidth: 800)
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.aptos(16))
    }
}

extension View {
    func appPageStyle() -> some View {
        self.modifier(AppPageStyle())
    }
}
