import SwiftUI

extension Color {
    static let appPrimary = Color(hex: "#10b981") // Emerald 500
    static let appSecondary = Color(hex: "#3b82f6") // Blue 500
    
    static let appBackground = Color.dynamic(light: "#bdd5edff", dark: "#0f172a")
    static let appCard = Color.dynamic(light: "#2f7b9cff", dark: "#1e293b")
    static let surface = Color.dynamic(light: "#f1f5f9", dark: "#1e293b") // Slate 100 / 800
    
    static func dynamic(light: String, dark: String) -> Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: dark)) : UIColor(Color(hex: light))
        })
        #elseif os(macOS)
        return Color(NSColor(name: nil) { appearance in
            return appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua ? NSColor(Color(hex: dark)) : NSColor(Color(hex: light))
        })
        #else
        return Color(hex: light)
        #endif
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
