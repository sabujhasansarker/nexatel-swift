import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let brand = BrandColor()
    struct BrandColor {
        let bg = Color(red: 0.95, green: 0.96, blue: 0.98)
        let black = Color(red: 0, green: 0.02, blue: 0.02)
        let border = Color(red: 0.91, green: 0.91, blue: 0.92)
        let gray = Color(red: 0.56, green: 0.56, blue: 0.58)
        let gray500 = Color(red: 0.47, green: 0.47, blue: 0.47)
        let primary = Color(red: 0.05, green: 0.69, blue: 0.45)
        let danger = Color(red: 1, green: 0.22, blue: 0.24)
    }
}

