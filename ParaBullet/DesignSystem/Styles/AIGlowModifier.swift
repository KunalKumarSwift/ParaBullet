import SwiftUI

struct AIGlowModifier: ViewModifier {
    let isActive: Bool
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isActive {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.appPrimary, .appSecondary, .appPrimary.opacity(0)]),
                                    center: .center,
                                    angle: .degrees(rotation)
                                ),
                                lineWidth: 4
                            )
                            .blur(radius: 8)
                            .opacity(0.8)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.appPrimary, .appSecondary, .appPrimary.opacity(0)]),
                                    center: .center,
                                    angle: .degrees(rotation)
                                ),
                                lineWidth: 2
                            )
                    }
                }
            )
            .shadow(color: .appPrimary.opacity(isActive ? 0.3 : 0), radius: 15, x: 0, y: 0)
            .onAppear {
                if isActive {
                    startAnimation()
                }
            }
            .onChange(of: isActive) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    rotation = 0
                }
            }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}

extension View {
    func aiGlow(isActive: Bool) -> some View {
        self.modifier(AIGlowModifier(isActive: isActive))
    }
}
