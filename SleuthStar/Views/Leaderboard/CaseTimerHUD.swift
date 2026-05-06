import SwiftUI

/// Floating stopwatch shown on the Crime Scene + Courtroom while a timed run is in progress.
struct CaseTimerHUD: View {
    @ObservedObject private var timer = CaseTimer.shared

    var body: some View {
        if timer.isRunning {
            TimelineView(.periodic(from: .now, by: 0.1)) { _ in
                content
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    private var content: some View {
        HStack(spacing: 8) {
            Image(systemName: "stopwatch.fill")
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(Theme.gold)
            Text(CaseTimer.format(seconds: timer.elapsedSeconds))
                .font(.system(size: 14, weight: .heavy, design: .monospaced))
                .foregroundStyle(Theme.textPrimary)
                .monospacedDigit()
                .contentTransition(.numericText())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Theme.coal.opacity(0.85))
        )
        .overlay(
            Capsule().strokeBorder(Theme.gold.opacity(0.45), lineWidth: 1)
        )
    }
}
