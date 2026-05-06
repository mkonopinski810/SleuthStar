import Foundation
import SwiftUI

enum AnalysisTool: String, Codable, CaseIterable, Identifiable {
    case magnifier
    case uvLight
    case evidenceKit
    case forensicAssistant

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .magnifier: return "Magnifier"
        case .uvLight: return "UV Flashlight"
        case .evidenceKit: return "Evidence Kit"
        case .forensicAssistant: return "Forensic Read"
        }
    }

    var iconName: String {
        switch self {
        case .magnifier: return "magnifyingglass.circle.fill"
        case .uvLight: return "flashlight.on.fill"
        case .evidenceKit: return "briefcase.fill"
        case .forensicAssistant: return "cross.case.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .magnifier: return Color(red: 1.00, green: 0.72, blue: 0.28)
        case .uvLight: return Color(red: 0.55, green: 0.50, blue: 0.95)
        case .evidenceKit: return Color(red: 0.42, green: 0.78, blue: 0.55)
        case .forensicAssistant: return Color(red: 0.95, green: 0.45, blue: 0.55)
        }
    }
}

enum AnalysisStrength: String, Codable {
    case strong
    case weak
    case inconclusive

    var displayName: String {
        switch self {
        case .strong: return "STRONG EVIDENCE"
        case .weak: return "WEAK CONNECTION"
        case .inconclusive: return "INCONCLUSIVE"
        }
    }

    var subtitle: String {
        switch self {
        case .strong: return "The bench will likely accept this."
        case .weak: return "Probably not material to the case."
        case .inconclusive: return "Could go either way. Risky to submit."
        }
    }

    var tintColor: Color {
        switch self {
        case .strong: return Color(red: 1.00, green: 0.72, blue: 0.28)
        case .weak: return Color(red: 0.78, green: 0.45, blue: 0.45)
        case .inconclusive: return Color(red: 0.66, green: 0.66, blue: 0.72)
        }
    }

    var iconName: String {
        switch self {
        case .strong: return "checkmark.seal.fill"
        case .weak: return "questionmark.diamond.fill"
        case .inconclusive: return "circle.dashed"
        }
    }
}

struct EvidenceAnalysis: Codable, Hashable {
    let magnifierFinding: String
    let uvFinding: String
    let labFinding: String
    let forensicVerdict: AnalysisStrength
    let forensicNote: String

    func finding(for tool: AnalysisTool) -> String {
        switch tool {
        case .magnifier: return magnifierFinding
        case .uvLight: return uvFinding
        case .evidenceKit: return labFinding
        case .forensicAssistant: return forensicNote
        }
    }
}
