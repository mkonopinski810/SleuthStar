import Foundation
import GameKit
import SwiftUI

@MainActor
final class GameCenterManager: ObservableObject {
    static let shared = GameCenterManager()

    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var displayName: String = ""
    @Published private(set) var lastAuthError: String?

    private init() {}

    /// Map case IDs to App Store Connect leaderboard IDs.
    /// You must create a leaderboard in ASC for each entry below before scores will save.
    /// Format: Integer, sort Low → High (lower time wins), display "Elapsed Time (mm:ss.SSS)".
    static let leaderboardIDs: [String: String] = [
        "case-001-rooftop":      "lb.case_001_rooftop",
        "case-001b-diner":       "lb.case_001b_diner",
        "case-001c-greenhouse":  "lb.case_001c_greenhouse",
        "case-001d-pawnshop":    "lb.case_001d_pawnshop",
        "case-001e-bakery":      "lb.case_001e_bakery",
        "case-001f-bookshop":    "lb.case_001f_bookshop",
        "case-001g-tailor":      "lb.case_001g_tailor",
        "case-001h-arcade":      "lb.case_001h_arcade",
        "case-001i-flowershop":  "lb.case_001i_flowershop",
        "case-001j-laundromat":  "lb.case_001j_laundromat",
        "case-001k-recordshop":  "lb.case_001k_recordshop",
        "case-001l-bodega":      "lb.case_001l_bodega",
        "case-001m-cobbler":     "lb.case_001m_cobbler",
        "case-002-midnight":     "lb.case_002_midnight",
        "case-002b-manuscript":  "lb.case_002b_manuscript",
        "case-002c-backlot":     "lb.case_002c_backlot",
        "case-002d-mayor":       "lb.case_002d_mayor",
        "case-002e-champagne":   "lb.case_002e_champagne",
        "case-003-diamond":      "lb.case_003_diamond",
        "case-003b-stadium":     "lb.case_003b_stadium",
        "case-003c-tunnel":      "lb.case_003c_tunnel",
        "case-003d-auction":     "lb.case_003d_auction",
        "case-004-masquerade":   "lb.case_004_masquerade",
        "case-004b-conductor":   "lb.case_004b_conductor",
        "case-004c-yacht":       "lb.case_004c_yacht"
    ]

    static func leaderboardID(for caseId: String) -> String? {
        leaderboardIDs[caseId]
    }

    /// Kick off Game Center authentication. Should be called once at app launch.
    /// If the player needs to log in, iOS will present its own sign-in sheet.
    func authenticate() {
        let player = GKLocalPlayer.local
        player.authenticateHandler = { [weak self] viewController, error in
            Task { @MainActor in
                guard let self else { return }
                if let error {
                    self.lastAuthError = error.localizedDescription
                    self.isAuthenticated = false
                    return
                }
                if viewController != nil {
                    // The OS wants us to present its sign-in sheet. We let the system handle it
                    // by leaving the player un-authenticated; iOS surfaces the prompt automatically
                    // on subsequent leaderboard interactions. Players can also sign in via Settings.
                    self.isAuthenticated = false
                    return
                }
                self.isAuthenticated = player.isAuthenticated
                self.displayName = player.isAuthenticated ? player.displayName : ""
                self.lastAuthError = nil
            }
        }
    }

    /// Submit a case-completion time to that case's leaderboard. No-op if not authenticated
    /// or if no leaderboard ID is registered for the case.
    func submitTime(caseId: String, milliseconds: Int) async {
        guard isAuthenticated else { return }
        guard let lbId = Self.leaderboardID(for: caseId) else { return }
        do {
            try await GKLeaderboard.submitScore(
                milliseconds,
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: [lbId]
            )
        } catch {
            // Silent on failure — don't block the verdict UI on a network hiccup.
            print("[GameCenter] submitTime failed for \(caseId): \(error.localizedDescription)")
        }
    }

    enum LeaderboardScope {
        case friends, global
    }

    struct Entry: Identifiable, Hashable {
        let id: String
        let rank: Int
        let displayName: String
        let milliseconds: Int
        let isLocalPlayer: Bool
    }

    struct LeaderboardSnapshot {
        let localPlayer: Entry?
        let topEntries: [Entry]
        let totalCount: Int
    }

    /// Fetch leaderboard entries for a given case + scope.
    func loadLeaderboard(
        caseId: String,
        scope: LeaderboardScope,
        topN: Int = 25
    ) async throws -> LeaderboardSnapshot {
        guard let lbId = Self.leaderboardID(for: caseId) else {
            return LeaderboardSnapshot(localPlayer: nil, topEntries: [], totalCount: 0)
        }
        let lbs = try await GKLeaderboard.loadLeaderboards(IDs: [lbId])
        guard let lb = lbs.first else {
            return LeaderboardSnapshot(localPlayer: nil, topEntries: [], totalCount: 0)
        }

        let playerScope: GKLeaderboard.PlayerScope
        switch scope {
        case .friends: playerScope = .friendsOnly
        case .global:  playerScope = .global
        }

        let (localPlayerEntry, topRaw, total) = try await lb.loadEntries(
            for: playerScope,
            timeScope: .allTime,
            range: NSRange(location: 1, length: max(1, topN))
        )

        let localId = GKLocalPlayer.local.gamePlayerID
        let topMapped = topRaw.map { entry in
            Entry(
                id: entry.player.gamePlayerID,
                rank: entry.rank,
                displayName: entry.player.displayName,
                milliseconds: entry.score,
                isLocalPlayer: entry.player.gamePlayerID == localId
            )
        }
        let mappedLocal = localPlayerEntry.map { entry in
            Entry(
                id: entry.player.gamePlayerID,
                rank: entry.rank,
                displayName: entry.player.displayName,
                milliseconds: entry.score,
                isLocalPlayer: true
            )
        }
        return LeaderboardSnapshot(
            localPlayer: mappedLocal,
            topEntries: topMapped,
            totalCount: total
        )
    }
}
