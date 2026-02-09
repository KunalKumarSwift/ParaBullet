import SwiftUI

extension Font {
    enum AptosWeight {
        case light, regular, semiBold, bold
        
        var name: String {
            switch self {
            case .light: return "Aptos-Light"
            case .regular: return "Aptos"
            case .semiBold: return "Aptos-SemiBold"
            case .bold: return "Aptos-Bold"
            }
        }
    }
    
    static func aptos(_ size: CGFloat, weight: AptosWeight = .regular) -> Font {
        return .custom(weight.name, size: size)
    }
}
