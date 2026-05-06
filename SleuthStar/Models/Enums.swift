import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case office
    case intro(caseId: String)
    case briefing(caseId: String)
    case crimeScene(caseId: String)
    case courtroom(caseId: String)
    case verdict(caseId: String, isGuilty: Bool, reward: Int, fine: Int)
    case shop
    case career
    case leaderboard
}

enum EvidenceType: String, Codable, CaseIterable {
    case fingerprint
    case note
    case weapon
    case bloodstain
    case footprint
    case hair
    case photograph
    case receipt

    var iconName: String {
        switch self {
        case .fingerprint: return "fingerprint.viewfinder"
        case .note: return "doc.text.fill"
        case .weapon: return "scope"
        case .bloodstain: return "drop.fill"
        case .footprint: return "shoeprints.fill"
        case .hair: return "scribble.variable"
        case .photograph: return "photo.fill"
        case .receipt: return "scroll.fill"
        }
    }

    var displayName: String {
        switch self {
        case .fingerprint: return "Fingerprint"
        case .note: return "Note"
        case .weapon: return "Weapon"
        case .bloodstain: return "Bloodstain"
        case .footprint: return "Footprint"
        case .hair: return "Hair Sample"
        case .photograph: return "Photograph"
        case .receipt: return "Receipt"
        }
    }

    var tintColor: Color {
        switch self {
        case .fingerprint: return Color(red: 1.00, green: 0.70, blue: 0.28)
        case .note: return Color(red: 0.95, green: 0.90, blue: 0.78)
        case .weapon: return Color(red: 0.78, green: 0.29, blue: 0.29)
        case .bloodstain: return Color(red: 0.78, green: 0.20, blue: 0.20)
        case .footprint: return Color(red: 0.62, green: 0.45, blue: 0.30)
        case .hair: return Color(red: 0.55, green: 0.55, blue: 0.60)
        case .photograph: return Color(red: 0.50, green: 0.70, blue: 0.85)
        case .receipt: return Color(red: 0.92, green: 0.85, blue: 0.65)
        }
    }
}

enum ShopCategory: String, Codable, CaseIterable, Identifiable {
    case equipment
    case clothing
    case assistant

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .equipment: return "Equipment"
        case .clothing: return "Wardrobe"
        case .assistant: return "Hire Assistant"
        }
    }

    var iconName: String {
        switch self {
        case .equipment: return "wrench.and.screwdriver.fill"
        case .clothing: return "tshirt.fill"
        case .assistant: return "person.badge.plus"
        }
    }
}

enum CaseDifficulty: String, Codable {
    case rookie
    case detective
    case veteran
    case master

    var displayName: String {
        switch self {
        case .rookie: return "ROOKIE"
        case .detective: return "DETECTIVE"
        case .veteran: return "VETERAN"
        case .master: return "MASTER"
        }
    }

    var tintColor: Color {
        switch self {
        case .rookie: return Color(red: 0.40, green: 0.78, blue: 0.55)
        case .detective: return Color(red: 0.45, green: 0.70, blue: 0.95)
        case .veteran: return Color(red: 0.95, green: 0.65, blue: 0.30)
        case .master: return Color(red: 0.86, green: 0.30, blue: 0.30)
        }
    }
}
