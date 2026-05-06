import SwiftUI

struct OfficeView: View {
    @EnvironmentObject var game: GameStateManager
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            NoirBackground()

            ScrollView {
                VStack(spacing: 22) {
                    OfficeHeader(fingerprints: game.profile.fingerprints)
                        .padding(.top, 4)

                    CareerCard {
                        path.append(AppRoute.career)
                    }

                    DetectiveStatCard(
                        solvedCount: game.profile.solvedCaseIds.count,
                        failedCount: game.profile.failedCaseIds.count,
                        ownedCount: game.profile.ownedItemIds.count
                    )

                    LeaderboardPill {
                        path.append(AppRoute.leaderboard)
                    }

                    TellAFriendPill()

                    OfficeRoomView(
                        onComputerTap: { path.append(AppRoute.shop) }
                    )

                    SectionHeader(title: "Case Files", subtitle: "Pick your next mystery", icon: "folder.fill")
                        .padding(.top, 6)

                    VStack(spacing: 14) {
                        ForEach(CaseRepository.allCases) { crime in
                            CaseCardView(
                                crimeCase: crime,
                                isUnlocked: game.isUnlocked(crime),
                                isSolved: game.profile.solvedCaseIds.contains(crime.id),
                                canAfford: game.profile.fingerprints >= crime.unlockCost,
                                prereqMet: prereqMet(for: crime),
                                prereqTitle: prereqTitle(for: crime),
                                onSelect: {
                                    if game.isUnlocked(crime) {
                                        path.append(AppRoute.intro(caseId: crime.id))
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func prereqMet(for crime: CrimeCase) -> Bool {
        guard let req = crime.requiresCaseId else { return true }
        return game.profile.solvedCaseIds.contains(req)
    }

    private func prereqTitle(for crime: CrimeCase) -> String? {
        guard let req = crime.requiresCaseId,
              !game.profile.solvedCaseIds.contains(req),
              let prereq = CaseRepository.byId(req) else { return nil }
        return prereq.title
    }
}

// MARK: - Office Header

private struct OfficeHeader: View {
    let fingerprints: Int

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("DETECTIVE'S OFFICE")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(3)
                    .foregroundStyle(Theme.gold)
                Text(AppInfo.appName)
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textPrimary)
                Text(AppInfo.tagline)
                    .font(.system(.footnote, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
            FingerprintCounterView(amount: fingerprints)
        }
    }
}

// MARK: - Stats card

private struct DetectiveStatCard: View {
    let solvedCount: Int
    let failedCount: Int
    let ownedCount: Int

    var body: some View {
        HStack(spacing: 14) {
            StatPill(value: "\(solvedCount)", label: "Solved", icon: "checkmark.seal.fill", color: Theme.leafGreen)
            StatPill(value: "\(failedCount)", label: "Lost", icon: "xmark.seal.fill", color: Theme.bloodRed)
            StatPill(value: "\(ownedCount)", label: "Gear", icon: "shippingbox.fill", color: Theme.gold)
        }
    }
}

private struct StatPill: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            Text(label.uppercased())
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .tracking(1.5)
                .foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .glassCard(corner: 14)
    }
}

// MARK: - Room (illustrated office)

private struct OfficeRoomView: View {
    let onComputerTap: () -> Void
    @State private var lampGlow = false

    var body: some View {
        ZStack {
            // Floor & wall
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [
                        Color(red: 0.13, green: 0.10, blue: 0.18),
                        Color(red: 0.18, green: 0.13, blue: 0.20)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 130)

                LinearGradient(
                    colors: [
                        Color(red: 0.22, green: 0.14, blue: 0.10),
                        Color(red: 0.10, green: 0.06, blue: 0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            // Lamp glow on the wall
            RadialGradient(
                colors: [Theme.gold.opacity(lampGlow ? 0.55 : 0.40), .clear],
                center: UnitPoint(x: 0.18, y: 0.10),
                startRadius: 0,
                endRadius: 220
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: lampGlow)

            // Furniture row
            HStack(alignment: .bottom, spacing: 18) {
                // Filing cabinet
                FurnitureBlock(icon: "archivebox.fill", label: "Files", height: 88, color: Color(red: 0.42, green: 0.28, blue: 0.18))

                // Computer (interactive!)
                ComputerWidget(action: onComputerTap)

                // Coat rack
                FurnitureBlock(icon: "figure.walk", label: "Coat", height: 110, color: Color(red: 0.30, green: 0.20, blue: 0.15))
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)

            // Desk lamp
            VStack {
                HStack {
                    Image(systemName: "lamp.desk.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Theme.gold)
                        .shadow(color: Theme.gold.opacity(0.7), radius: lampGlow ? 14 : 8)
                        .padding(14)
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(height: 200)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Theme.gold.opacity(0.25), lineWidth: 1)
        )
        .onAppear { lampGlow = true }
    }
}

private struct FurnitureBlock: View {
    let icon: String
    let label: String
    let height: CGFloat
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
            Text(label.uppercased())
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(width: 64, height: height)
        .padding(.bottom, 8)
        .background(
            LinearGradient(
                colors: [color.opacity(0.95), color.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 6).strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.5), radius: 6, y: 4)
    }
}

private struct ComputerWidget: View {
    let action: () -> Void
    @State private var blink = false

    var body: some View {
        Button(action: { Haptics.tap(); action() }) {
            VStack(spacing: 0) {
                // Monitor
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color(red: 0.10, green: 0.10, blue: 0.16))

                    // Glowing screen content
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 3) {
                            Circle().fill(Theme.bloodRed).frame(width: 4, height: 4)
                            Circle().fill(Theme.gold).frame(width: 4, height: 4)
                            Circle().fill(Theme.leafGreen).frame(width: 4, height: 4)
                            Spacer()
                        }
                        Text(">_ shop")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(Theme.leafGreen)
                            .opacity(blink ? 1 : 0.4)
                        Text("ONLINE")
                            .font(.system(size: 8, weight: .heavy, design: .monospaced))
                            .foregroundStyle(Theme.gold)
                    }
                    .padding(6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(width: 96, height: 64)
                .overlay(
                    RoundedRectangle(cornerRadius: 6).strokeBorder(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Theme.leafGreen.opacity(0.3), radius: 12)

                // Stand
                Rectangle()
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.20))
                    .frame(width: 24, height: 8)

                // Base
                Rectangle()
                    .fill(Color(red: 0.10, green: 0.10, blue: 0.14))
                    .frame(width: 64, height: 6)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            }
            .padding(.bottom, 6)
            .overlay(alignment: .bottom) {
                Text("TAP")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(1.5)
                    .foregroundStyle(Theme.gold)
                    .offset(y: 14)
            }
        }
        .buttonStyle(PressableButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                blink = true
            }
        }
    }
}

// MARK: - Case card

private struct CaseCardView: View {
    let crimeCase: CrimeCase
    let isUnlocked: Bool
    let isSolved: Bool
    let canAfford: Bool
    let prereqMet: Bool
    let prereqTitle: String?
    let onSelect: () -> Void

    var body: some View {
        Button(action: { Haptics.tap(); onSelect() }) {
            HStack(alignment: .top, spacing: 14) {
                // Scene icon panel
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: crimeCase.sceneTint[0], green: crimeCase.sceneTint[1], blue: crimeCase.sceneTint[2]),
                                    Color(red: crimeCase.sceneTint[0] * 0.5, green: crimeCase.sceneTint[1] * 0.5, blue: crimeCase.sceneTint[2] * 0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: crimeCase.sceneIcon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white.opacity(0.92))
                        .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
                }
                .frame(width: 76, height: 76)
                .overlay(
                    RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.15), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        DifficultyBadge(difficulty: crimeCase.difficulty)
                        if isSolved {
                            Text("SOLVED")
                                .font(.system(size: 9, weight: .heavy, design: .rounded))
                                .tracking(1.2)
                                .foregroundStyle(Theme.leafGreen)
                                .padding(.horizontal, 6).padding(.vertical, 3)
                                .background(Theme.leafGreen.opacity(0.18))
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    Text(crimeCase.title)
                        .font(.system(.headline, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)
                    Text(crimeCase.blurb)
                        .font(.system(size: 12, design: .serif))
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)

                    HStack(spacing: 10) {
                        if isUnlocked {
                            Label("\(crimeCase.reward)", systemImage: "fingerprint")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.gold)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Theme.gold)
                        } else if !prereqMet, let prereqTitle {
                            Label("Solve \(prereqTitle) first", systemImage: "lock.fill")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textMuted)
                                .lineLimit(1)
                        } else {
                            Label("\(crimeCase.unlockCost) to unlock", systemImage: "lock.fill")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundStyle(canAfford ? Theme.gold : Theme.textMuted)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(14)
            .glassCard(corner: 16)
            .opacity(isUnlocked ? 1.0 : 0.86)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!isUnlocked && !canAfford)
    }
}

private struct DifficultyBadge: View {
    let difficulty: CaseDifficulty
    var body: some View {
        Text(difficulty.displayName)
            .font(.system(size: 9, weight: .heavy, design: .rounded))
            .tracking(1.5)
            .foregroundStyle(difficulty.tintColor)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(difficulty.tintColor.opacity(0.16))
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(difficulty.tintColor.opacity(0.4), lineWidth: 1))
    }
}

// MARK: - Leaderboard pill

private struct LeaderboardPill: View {
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.tap()
            action()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Theme.gold.opacity(0.18))
                        .frame(width: 38, height: 38)
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.gold)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("TIME ATTACK")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(Theme.gold)
                    Text("Leaderboard · Game Center")
                        .font(.system(.subheadline, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.textMuted)
            }
            .padding(12)
            .glassCard(corner: 14)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

private struct TellAFriendPill: View {
    private var appStoreURL: URL {
        ForceUpdateChecker.appStoreURL
    }

    private var shareMessage: String {
        "Solving noir cases in Sleuth Star. Try it: \(appStoreURL.absoluteString)"
    }

    var body: some View {
        ShareLink(
            item: appStoreURL,
            subject: Text("Sleuth Star"),
            message: Text(shareMessage)
        ) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.55, green: 0.50, blue: 0.95).opacity(0.18))
                        .frame(width: 38, height: 38)
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(red: 0.65, green: 0.60, blue: 1.00))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("TELL A FRIEND")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(Color(red: 0.65, green: 0.60, blue: 1.00))
                    Text("Share Sleuth Star")
                        .font(.system(.subheadline, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
                Spacer()
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.textMuted)
            }
            .padding(12)
            .glassCard(corner: 14)
        }
        .simultaneousGesture(TapGesture().onEnded { Haptics.tap() })
    }
}
