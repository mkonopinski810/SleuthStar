import SwiftUI

struct BriefingView: View {
    let crimeCase: CrimeCase
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            NoirBackground(tint: Color(red: crimeCase.sceneTint[0], green: crimeCase.sceneTint[1], blue: crimeCase.sceneTint[2]))

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Top bar
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
                        Text("CASE FILE")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .tracking(2.4)
                            .foregroundStyle(Theme.gold)
                    }
                    .padding(.top, 4)

                    // Hero scene plate
                    ZStack {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: crimeCase.sceneTint[0], green: crimeCase.sceneTint[1], blue: crimeCase.sceneTint[2]),
                                        Color(red: crimeCase.sceneTint[0] * 0.4, green: crimeCase.sceneTint[1] * 0.4, blue: crimeCase.sceneTint[2] * 0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)
                        Image(systemName: crimeCase.sceneIcon)
                            .font(.system(size: 90, weight: .bold))
                            .foregroundStyle(.white.opacity(0.85))
                            .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 22).strokeBorder(.white.opacity(0.18), lineWidth: 1)
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        DifficultyTag(difficulty: crimeCase.difficulty)
                        Text(crimeCase.title)
                            .font(.system(.largeTitle, design: .serif).weight(.bold))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(2)
                        Text(crimeCase.location)
                            .font(.system(.subheadline, design: .serif).italic())
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Text(crimeCase.blurb)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Theme.textPrimary.opacity(0.9))
                        .padding(16)
                        .glassCard(corner: 14)

                    SuspectCard(suspect: crimeCase.suspect)

                    BriefingStat(crimeCase: crimeCase)

                    Spacer(minLength: 4)

                    PrimaryButton(
                        title: "Enter Crime Scene",
                        systemImage: "magnifyingglass",
                        style: .gold
                    ) {
                        path.append(AppRoute.crimeScene(caseId: crimeCase.id))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct DifficultyTag: View {
    let difficulty: CaseDifficulty
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "shield.lefthalf.filled")
                .font(.system(size: 10, weight: .heavy))
            Text(difficulty.displayName)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .tracking(2)
        }
        .foregroundStyle(difficulty.tintColor)
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(difficulty.tintColor.opacity(0.16))
        .clipShape(Capsule())
        .overlay(Capsule().strokeBorder(difficulty.tintColor.opacity(0.5), lineWidth: 1))
    }
}

private struct SuspectCard: View {
    let suspect: Suspect

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.midnight, .black],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 64, height: 64)
                Image(systemName: suspect.profileSilhouette)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Theme.textMuted)
            }
            .overlay(Circle().strokeBorder(Theme.bloodRed.opacity(0.5), lineWidth: 1.5))

            VStack(alignment: .leading, spacing: 4) {
                Text("PRIMARY SUSPECT")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(1.8)
                    .foregroundStyle(Theme.bloodRed)
                Text("\"\(suspect.alias)\"")
                    .font(.system(.title3, design: .serif).weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(suspect.known)
                    .font(.system(.caption, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .glassCard(corner: 14)
    }
}

private struct BriefingStat: View {
    let crimeCase: CrimeCase

    var body: some View {
        HStack(spacing: 12) {
            statBlock(
                icon: "fingerprint",
                value: "\(crimeCase.reward)",
                label: "Reward",
                color: Theme.gold
            )
            statBlock(
                icon: "exclamationmark.triangle.fill",
                value: "\(crimeCase.fineOnLoss)",
                label: "Fine",
                color: Theme.bloodRed
            )
            statBlock(
                icon: "checkmark.shield.fill",
                value: "\(crimeCase.minIncriminatingToWin)",
                label: "Min Evidence",
                color: Theme.leafGreen
            )
        }
    }

    private func statBlock(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
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
