import SwiftUI

/// Bespoke palette for Pinboard Log -- Catalog enamel pin or patch collections by set and display board.
enum Theme {
    static let accent = Color(hex: "#E0507A")
    static let background = Color(hex: "#170D14")
    static let backgroundSecondary = Color(hex: "#20121B")
    static let card = Color(hex: "#2A1822")
    static let textPrimary = Color(hex: "#F8E9EF")
    static let textSecondary = Color(hex: "#EEA8BF")

    static var titleFont: Font { Font.system(.title2, design: .rounded).weight(.bold) }
    static var bodyFont: Font { Font.system(.body, design: .rounded) }
    static var captionFont: Font { Font.system(.caption, design: .rounded) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
