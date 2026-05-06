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
        "case-001-rooftop":     "lb.case_001_rooftop",
        "case-001b-diner":      "lb.case_001b_diner",
        "case-001c-greenhouse": "lb.case_001c_greenhouse",
        "case-002-midnight":    "lb.case_002_midnight",
        "case-003-diamond":     "lb.case_003_diamond",
        "case-004-masquerade":  "lb.case_004_masquerade"
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
