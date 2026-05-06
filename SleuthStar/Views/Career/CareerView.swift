import SwiftUI

struct CareerView: View {
    @EnvironmentObject var game: GameStateManager
    @Environment(\.dismiss) private var dismiss

    private var rank: CareerRank { game.currentRank() }
    private var next: CareerRank? { game.nextRank() }
    private var progress: Double { game.progressToNextRank() }

    var body: some View {
        ZStack {
            NoirBackground(tint: rank.tintColor.opacity(0.5))

            ScrollView {
                VStack(spacing: 18) {
                    topBar
                        .padding(.top, 4)

                    heroBadge
                        .padding(.top, 10)

                    progressCard

                    statsRow

                    SectionHeader(
                        title: "Career Ladder",
                        subtitle: "Earn promotions by closing cases",
                        icon: "list.bullet.rectangle.portrait.fill"
                    )
                    .padding(.top, 8)

                    VStack(spacing: 8) {
                        ForEach(CareerRank.allCases, id: \.self) { r in
                            RankRow(
                                rank: r,
                                isCurrent: r == rank,
                                isUnlocked: r.rawValue <= rank.rawValue,
                                solvedNow: game.profile.solvedCaseIds.count,
                                lifetimeNow: game.profile.lifetimeFingerprints
                            )
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 34)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topBar: some View {
        HStack {
            Button {
                Haptics.tap()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                    .frame(width: 36, height: 36)
                    .glassCard(corner: 12)
            }
            Spacer()
            Text("CAREER")
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .tracking(3)
                .foregroundStyle(Theme.gold)
            Spacer()
            Color.clear.frame(width: 36)
        }
    }

    private var heroBadge: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(rank.tintColor.opacity(0.20))
                    .frame(width: 180, height: 180)
                    .blur(radius: 14)
                Circle()
                    .strokeBorder(rank.tintColor.opacity(0.6), lineWidth: 2)
                    .frame(width: 130, height: 130)
                Image(systemName: rank.iconName)
                    .font(.system(size: 64, weight: .black))
                    .foregroundStyle(rank.tintColor)
                    .shadow(color: rank.tintColor.opacity(0.7), radius: 14)
            }

            VStack(spacing: 4) {
                Text("CURRENT RANK")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(Theme.gold)
                Text(rank.displayName)
                    .font(.system(.largeTitle, design: .serif).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text(rank.subtitle)
                    .font(.system(.subheadline, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
    }

    private var progressCard: some View {
        VStack(spacing: 12) {
            if let next {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("NEXT PROMOTION")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .tracking(2)
                            .foregroundStyle(Theme.textMuted)
                        Text(next.displayName)
                            .font(.system(.title3, design: .serif).weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                    }
                    Spacer()
                    Image(systemName: next.iconName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(next.tintColor)
                }

                HStack(spacing: 12) {
                    requirementBlock(
                        icon: "checkmark.seal.fill",
                        label: "Cases Solved",
                        current: game.profile.solvedCaseIds.count,
                        required: next.solvedRequired,
                        color: Theme.leafGreen
                    )
                    requirementBlock(
                        icon: "fingerprint",
                        label: "Lifetime Earned",
                        current: game.profile.lifetimeFingerprints,
                        required: next.lifetimeRequired,
                        color: Theme.gold
                    )
                }

                if let perk = next.perk {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkle")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundStyle(next.tintColor)
                        Text("Unlocks: \(perk)")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.textPrimary.opacity(0.92))
                        Spacer()
                    }
                }
            } else {
                VStack(spacing: 6) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Theme.gold)
                    Text("Top of the Force")
                        .font(.system(.title2, design: .serif).weight(.bold))
                        .foregroundStyle(Theme.gold)
                    Text("There is no rank above this one. The bench takes your call.")
                        .font(.system(.subheadline, design: .serif).italic())
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
            }
        }
        .padding(14)
        .glassCard(corner: 16)
    }

    private func requirementBlock(icon: String, label: String, current: Int, required: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(color)
                Text(label.uppercased())
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(1.4)
                    .foregroundStyle(Theme.textMuted)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("\(current.formattedFingerprints)")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                    .monospacedDigit()
                Text("/ \(required.formattedFingerprints)")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textMuted)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(color.opacity(0.3), lineWidth: 1)
        )
    }

    private var statsRow: some View {
        HStack(spacing: 10) {
            statBlock(value: "\(game.profile.solvedCaseIds.count)", label: "Solved", icon: "checkmark.seal.fill", color: Theme.leafGreen)
            statBlock(value: "\(game.profile.failedCaseIds.count)", label: "Lost", icon: "xmark.seal.fill", color: Theme.bloodRed)
            statBlock(value: game.profile.lifetimeFingerprints.formattedFingerprints, label: "Lifetime", icon: "fingerprint", color: Theme.gold)
        }
    }

    private func statBlock(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            Text(label.uppercased())
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .glassCard(corner: 12)
    }
}

private struct RankRow: View {
    let rank: CareerRank
    let isCurrent: Bool
    let isUnlocked: Bool
    let solvedNow: Int
    let lifetimeNow: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(rank.tintColor.opacity(isUnlocked ? 0.20 : 0.06))
                    .frame(width: 40, height: 40)
                Image(systemName: rank.iconName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(isUnlocked ? rank.tintColor : Theme.textMuted)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(rank.displayName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isUnlocked ? Theme.textPrimary : Theme.textSecondary)
                    if isCurrent {
                        Text("YOU")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .tracking(1.5)
                            .foregroundStyle(Theme.midnight)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Theme.gold)
                            .clipShape(Capsule())
                    }
                }
                Text("\(rank.solvedRequired) solved · \(rank.lifetimeRequired.formattedFingerprints) lifetime")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textMuted)
            }

            Spacer()

            if !isUnlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.textMuted)
            } else if isCurrent {
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(rank.tintColor)
            } else {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(rank.tintColor.opacity(0.8))
            }
        }
        .padding(12)
        .glassCard(corner: 12)
        .opacity(isUnlocked ? 1.0 : 0.7)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isCurrent ? rank.tintColor : Color.clear, lineWidth: 1.2)
        )
    }
}
