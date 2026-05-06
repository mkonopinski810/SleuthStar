import Foundation
import SwiftUI

/// Tracks elapsed time for a single in-progress case run.
/// The timer starts when the player enters the crime scene and stops the moment a guilty verdict is rendered.
@MainActor
final class CaseTimer: ObservableObject {
    static let shared = CaseTimer()

    @Published private(set) var startTime: Date?
    @Published private(set) var stopTime: Date?
    @Published private(set) var caseId: String?

    private init() {}

    var isRunning: Bool { startTime != nil && stopTime == nil }

    var elapsedSeconds: Double {
        guard let start = startTime else { return 0 }
        let end = stopTime ?? Date()
        return end.timeIntervalSince(start)
    }

    var elapsedMilliseconds: Int {
        Int(elapsedSeconds * 1000)
    }

    func start(caseId: String) {
        // If we're already running for the same case, leave it alone (re-entrancy from view re-appears).
        if isRunning && self.caseId == caseId { return }
        self.caseId = caseId
        self.startTime = Date()
        self.stopTime = nil
    }

    /// Stops the timer and returns the final result (caseId + ms). Returns nil if not running.
    @discardableResult
    func stop() -> (caseId: String, milliseconds: Int)? {
        guard let start = startTime, let id = caseId, stopTime == nil else { return nil }
        let now = Date()
        stopTime = now
        return (id, Int(now.timeIntervalSince(start) * 1000))
    }

    func reset() {
        startTime = nil
        stopTime = nil
        caseId = nil
    }

    /// Format elapsed time as mm:ss.t (tenths of a second).
    static func format(seconds: Double) -> String {
        let totalTenths = Int(seconds * 10)
        let tenths = totalTenths % 10
        let secs = (totalTenths / 10) % 60
        let mins = totalTenths / 600
        return String(format: "%02d:%02d.%d", mins, secs, tenths)
    }

    /// Format milliseconds as mm:ss.t — for displaying historical times from the leaderboard.
    static func format(milliseconds: Int) -> String {
        format(seconds: Double(milliseconds) / 1000)
    }
}
