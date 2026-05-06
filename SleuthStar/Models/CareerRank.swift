import Foundation
import SwiftUI

enum CareerRank: Int, CaseIterable, Codable, Hashable {
    case rookie = 0
    case patrolman
    case detective
    case seniorDetective
    case inspector
    case lieutenant
    case captain
    case starSleuth

    var displayName: String {
        switch self {
        case .rookie: return "Rookie"
        case .patrolman: return "Patrolman"
        case .detective: return "Detective"
        case .seniorDetective: return "Senior Detective"
        case .inspector: return "Inspector"
        case .lieutenant: return "Lieutenant"
        case .captain: return "Captain"
        case .starSleuth: return "Star Sleuth"
        }
    }

    var subtitle: String {
        switch self {
        case .rookie: return "Just badged. The bench has never heard of you."
        case .patrolman: return "First conviction. The street learns your name."
        case .detective: return "Real cases. Real suspects. Real sleep deprivation."
        case .seniorDetective: return "The bench remembers your face."
        case .inspector: return "They run cases past you before charging."
        case .lieutenant: return "You pick the cases. The cases don't pick you."
        case .captain: return "Top of the force. Pen in pocket, files on desk."
        case .starSleuth: return "Legend. They write books about you."
        }
    }

    var iconName: String {
        switch self {
        case .rookie: return "shield.lefthalf.filled"
        case .patrolman: return "shield.fill"
        case .detective: return "magnifyingglass.circle.fill"
        case .seniorDetective: return "rosette"
        case .inspector: return "checkerboard.shield"
        case .lieutenant: return "star.leadinghalf.filled"
        case .captain: return "star.fill"
        case .starSleuth: return "crown.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .rookie: return Color(red: 0.66, green: 0.66, blue: 0.72)
        case .patrolman: return Color(red: 0.45, green: 0.70, blue: 0.95)
        case .detective: return Color(red: 0.42, green: 0.78, blue: 0.55)
        case .seniorDetective: return Color(red: 0.55, green: 0.90, blue: 0.42)
        case .inspector: return Color(red: 1.00, green: 0.72, blue: 0.28)
        case .lieutenant: return Color(red: 1.00, green: 0.55, blue: 0.18)
        case .captain: return Color(red: 0.86, green: 0.30, blue: 0.30)
        case .starSleuth: return Color(red: 1.00, green: 0.30, blue: 0.55)
        }
    }

    /// Cases solved required to reach this rank
    var solvedRequired: Int {
        switch self {
        case .rookie: return 0
        case .patrolman: return 1
        case .detective: return 3
        case .seniorDetective: return 6
        case .inspector: return 10
        case .lieutenant: return 15
        case .captain: return 20
        case .starSleuth: return 25
        }
    }

    /// Lifetime fingerprints earned required to reach this rank
    var lifetimeRequired: Int {
        switch self {
        case .rookie: return 0
        case .patrolman: return 300
        case .detective: return 1200
        case .seniorDetective: return 3000
        case .inspector: return 7000
        case .lieutenant: return 14000
        case .captain: return 25000
        case .starSleuth: return 50000
        }
    }

    var perk: String? {
        switch self {
        case .rookie: return nil
        case .patrolman: return "+5 starter fingerprints per case"
        case .detective: return "Unlock the Detective tier"
        case .seniorDetective: return "Bench gives you the benefit of the doubt"
        case .inspector: return "Unlock the Veteran tier"
        case .lieutenant: return "Bigger reward on guilty verdicts"
        case .captain: return "Unlock the Master tier"
        case .starSleuth: return "Hall of fame · all titles unlocked"
        }
    }

    var isFinal: Bool { self == .starSleuth }

    /// The next rank above this one, or nil if Star Sleuth.
    var next: CareerRank? {
        CareerRank(rawValue: rawValue + 1)
    }
}
