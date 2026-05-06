import SwiftUI

enum Theme {
    // Deep noir base
    static let midnight = Color(red: 0.04, green: 0.05, blue: 0.13)
    static let ink      = Color(red: 0.07, green: 0.09, blue: 0.20)
    static let smoke    = Color(red: 0.13, green: 0.16, blue: 0.30)
    static let coal     = Color(red: 0.10, green: 0.12, blue: 0.22)

    // Accents
    static let gold     = Color(red: 1.00, green: 0.72, blue: 0.28)
    static let goldDeep = Color(red: 0.82, green: 0.55, blue: 0.16)
    static let parchment = Color(red: 0.96, green: 0.91, blue: 0.79)
    static let bloodRed = Color(red: 0.78, green: 0.22, blue: 0.22)
    static let leafGreen = Color(red: 0.42, green: 0.78, blue: 0.55)
    static let twilight = Color(red: 0.45, green: 0.55, blue: 0.95)

    // Text
    static let textPrimary   = Color(red: 0.96, green: 0.96, blue: 0.99)
    static let textSecondary = Color(red: 0.66, green: 0.69, blue: 0.80)
    static let textMuted     = Color(red: 0.46, green: 0.49, blue: 0.60)

    // Gradients
    static var noirBackground: LinearGradient {
        LinearGradient(
            colors: [midnight, ink, Color(red: 0.10, green: 0.07, blue: 0.18)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [gold, goldDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var glassFill: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.08),
                Color.white.opacity(0.02)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var glassStroke: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.30),
                Color.white.opacity(0.05)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Font {
    static var detective: Font { .system(.body, design: .serif) }
    static var detectiveTitle: Font { .system(.largeTitle, design: .serif).weight(.bold) }
    static var detectiveHeadline: Font { .system(.title2, design: .serif).weight(.semibold) }
    static var detectiveCaption: Font { .system(.caption, design: .serif).italic() }
}
