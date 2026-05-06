import SwiftUI

struct CareerCard: View {
    @EnvironmentObject var game: GameStateManager
    let onTap: () -> Void

    private var rank: CareerRank { game.currentRank() }
    private var next: CareerRank? { game.nextRank() }
    private var progress: Double { game.progressToNextRank() }

    var body: some View {
        Button {
            Haptics.tap()
            onTap()
        } label: {
            HStack(alignment: .center, spacing: 14) {
                // Rank badge
                ZStack {
                    Circle()
                        .fill(rank.tintColor.opacity(0.18))
                        .frame(width: 60, height: 60)
                    Circle()
                        .strokeBorder(rank.tintColor.opacity(0.6), lineWidth: 1.5)
                        .frame(width: 50, height: 50)
                    Image(systemName: rank.iconName)
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(rank.tintColor)
                        .shadow(color: rank.tintColor.opacity(0.5), radius: 6)
                }

                // Title + progress
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("RANK")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .tracking(2)
                            .foregroundStyle(Theme.textMuted)
                        Text(rank.displayName.uppercased())
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .tracking(1.4)
                            .foregroundStyle(rank.tintColor)
                    }

                    if let next {
                        Text("Next: \(next.displayName)")
                            .font(.system(.subheadline, design: .serif).weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)
                        ProgressBar(progress: progress, color: next.tintColor)
                            .frame(height: 5)
                            .padding(.top, 2)
                        Text(progressDetail)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.textMuted)
                    } else {
                        Text("Top of the Force")
                            .font(.system(.subheadline, design: .serif).weight(.semibold).italic())
                            .foregroundStyle(Theme.gold)
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(Theme.textMuted)
            }
            .padding(14)
            .glassCard(corner: 16)
        }
        .buttonStyle(PressableButtonStyle())
    }

    private var progressDetail: String {
        guard let next else { return "" }
        let solved = game.profile.solvedCaseIds.count
        let lifetime = game.profile.lifetimeFingerprints
        let solvedNeed = max(0, next.solvedRequired - solved)
        let fpNeed = max(0, next.lifetimeRequired - lifetime)
        if solvedNeed == 0 && fpNeed == 0 {
            return "Promotion ready"
        }
        if solvedNeed > 0 && fpNeed > 0 {
            return "\(solvedNeed) cases · \(fpNeed.formattedFingerprints) fp to go"
        }
        if solvedNeed > 0 {
            return "\(solvedNeed) more case\(solvedNeed == 1 ? "" : "s") to go"
        }
        return "\(fpNeed.formattedFingerprints) fp to go"
    }
}

private struct ProgressBar: View {
    let progress: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.10))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(6, geo.size.width * CGFloat(min(1.0, max(0.0, progress)))))
                    .shadow(color: color.opacity(0.6), radius: 4)
            }
        }
    }
}
