import Foundation
import SwiftUI

@MainActor
final class GameStateManager: ObservableObject {
    static let shared = GameStateManager()

    @Published var profile: PlayerProfile {
        didSet { save() }
    }

    private let storageKey = "sleuthstar.profile.v1"

    private init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(PlayerProfile.self, from: data) {
            self.profile = decoded
        } else {
            self.profile = .starter
        }
    }

    // MARK: - Currency

    func addFingerprints(_ amount: Int) {
        profile.fingerprints = max(0, profile.fingerprints + amount)
    }

    func spendFingerprints(_ amount: Int) -> Bool {
        guard profile.fingerprints >= amount else { return false }
        profile.fingerprints -= amount
        return true
    }

    // MARK: - Cases

    func recordVerdict(_ verdict: VerdictResult) {
        if verdict.isGuilty {
            profile.solvedCaseIds.insert(verdict.caseId)
            addFingerprints(verdict.reward)
            profile.lifetimeFingerprints += verdict.reward
        } else {
            profile.failedCaseIds.insert(verdict.caseId)
            addFingerprints(-verdict.fine)
        }
    }

    // MARK: - Career rank

    func currentRank() -> CareerRank {
        let solved = profile.solvedCaseIds.count
        let lifetime = profile.lifetimeFingerprints
        var best: CareerRank = .rookie
        for rank in CareerRank.allCases {
            if solved >= rank.solvedRequired && lifetime >= rank.lifetimeRequired {
                best = rank
            } else {
                break
            }
        }
        return best
    }

    func nextRank() -> CareerRank? {
        currentRank().next
    }

    /// Returns 0..<1 normalized progress to the next rank, weighted across both axes.
    func progressToNextRank() -> Double {
        guard let next = nextRank() else { return 1.0 }
        let cur = currentRank()
        let solved = profile.solvedCaseIds.count
        let lifetime = profile.lifetimeFingerprints

        let solvedSpan = max(1, next.solvedRequired - cur.solvedRequired)
        let solvedDone = max(0, solved - cur.solvedRequired)
        let solvedFrac = min(1.0, Double(solvedDone) / Double(solvedSpan))

        let fpSpan = max(1, next.lifetimeRequired - cur.lifetimeRequired)
        let fpDone = max(0, lifetime - cur.lifetimeRequired)
        let fpFrac = min(1.0, Double(fpDone) / Double(fpSpan))

        // Weight evenly across both axes
        return (solvedFrac + fpFrac) / 2.0
    }

    // MARK: - Equipment-driven multipliers (stack)

    var rewardMultiplier: Double {
        var m = 1.0
        if owns("wd-badge")  { m += 0.10 }
        if owns("wd-trench") { m += 0.05 }
        if owns("wd-fedora") { m += 0.02 }
        return m
    }

    var fineMultiplier: Double {
        var m = 1.0
        if owns("wd-suit")   { m -= 0.20 }
        if owns("wd-gloves") { m -= 0.05 }
        return max(0.5, m)
    }

    // MARK: - Sparkle pre-reveal (Rookie + Tail assistants)

    /// How many sparkles should be auto-revealed when entering a crime scene.
    var prerevealedSparkleCount: Int {
        var n = 0
        if owns("as-rookie") { n += 1 }
        if owns("as-tail")   { n += 2 }
        return n
    }

    /// Whether incriminating sparkles should be tinted gold on the scene.
    var hintsIncriminatingSparkles: Bool {
        owns("as-informant")
    }

    /// Whether the intro cutscene should auto-skip to briefing.
    var skipIntroCutscene: Bool {
        owns("as-driver")
    }

    /// Whether collected evidence should show a Polaroid badge in the inventory.
    var showsPolaroidBadge: Bool {
        owns("eq-polaroid")
    }

    // MARK: - Analysis text bonuses

    /// Returns the displayed finding text for a tool, with any owned-perk bonuses appended.
    func displayFinding(for tool: AnalysisTool, evidence: Evidence) -> String {
        let base = evidence.analysis?.finding(for: tool) ?? ""
        var suffix = ""
        switch tool {
        case .magnifier:
            if owns("eq-print-kit") && evidence.type == .fingerprint {
                suffix = " · AFIS check returns a hit at 89% confidence."
            }
        case .uvLight:
            if owns("as-cipher") && evidence.type == .note {
                suffix = " · Cipher resolves a numeric sequence in the margin: 4-7-1-9."
            }
        case .evidenceKit:
            if owns("eq-microscope") {
                suffix = " · Microscopic detail confirms the trace pattern at 92%."
            }
        case .forensicAssistant:
            break
        }
        return base + suffix
    }

    func isUnlocked(_ crimeCase: CrimeCase) -> Bool {
        if profile.solvedCaseIds.contains(crimeCase.id) { return true }
        if let req = crimeCase.requiresCaseId,
           !profile.solvedCaseIds.contains(req) {
            return false
        }
        return crimeCase.unlockCost == 0
    }

    // MARK: - Shop

    func owns(_ itemId: String) -> Bool {
        profile.ownedItemIds.contains(itemId)
    }

    func hasAnalysisTool(_ tool: AnalysisTool) -> Bool {
        ShopRepository.allItems.contains { item in
            item.analysisTool == tool && profile.ownedItemIds.contains(item.id)
        }
    }

    func shopItem(forAnalysisTool tool: AnalysisTool) -> ShopItem? {
        ShopRepository.allItems.first { $0.analysisTool == tool }
    }

    @discardableResult
    func purchase(_ item: ShopItem) -> Bool {
        guard !owns(item.id) else { return false }
        guard !item.comingSoon else { return false }
        guard spendFingerprints(item.price) else { return false }
        profile.ownedItemIds.insert(item.id)
        return true
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func resetForDebug() {
        profile = .starter
    }
}
