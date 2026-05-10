import SwiftUI

struct LeaderboardView: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var game: GameStateManager
    @ObservedObject private var gc = GameCenterManager.shared

    @State private var selectedCase: CrimeCase = CaseRepository.first()
    @State private var scope: GameCenterManager.LeaderboardScope = .friends
    @State private var snapshot: GameCenterManager.LeaderboardSnapshot?
    @State private var loading = false
    @State private var loadError: String?
    @State private var showCasePicker = false

    var body: some View {
        ZStack {
            NoirBackground()
            ScrollView {
                VStack(spacing: 16) {
                    topBar
                    if !gc.isAuthenticated {
                        notSignedInCard
                    } else {
                        casePicker
                        attemptButton
                        if GameCenterManager.hasLiveLeaderboard(for: selectedCase.id) {
                            scopePicker
                            leaderboardBody
                        } else {
                            comingSoonCard
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task(id: scopeKey) {
            await loadSnapshot()
        }
        .sheet(isPresented: $showCasePicker) {
            casePickerSheet
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Theme.ink)
        }
    }

    // MARK: - Top bar

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
            VStack(spacing: 1) {
                Text("LEADERBOARD")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(Theme.gold)
                Text("Time Attack")
                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            Spacer()
            Color.clear.frame(width: 36)
        }
        .padding(.top, 4)
    }

    // MARK: - Not signed in

    private var notSignedInCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 56, weight: .heavy))
                .foregroundStyle(Theme.gold)
                .padding(.top, 24)
            VStack(spacing: 6) {
                Text("Sign in to Game Center")
                    .font(.system(.title3, design: .serif).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Time-attack scores and friend leaderboards use Apple's Game Center. Sign in from iOS Settings → Game Center to compete.")
                    .font(.system(.subheadline, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
            }
            if let err = gc.lastAuthError {
                Text(err)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Theme.bloodRed)
                    .padding(.top, 4)
            }
            Spacer(minLength: 12)
        }
        .padding(20)
        .glassCard(corner: 16)
    }

    // MARK: - Coming soon

    private var comingSoonCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy.circle")
                .font(.system(size: 46, weight: .heavy))
                .foregroundStyle(Theme.gold)
                .padding(.top, 18)
            Text("Leaderboard arriving soon")
                .font(.system(.title3, design: .serif).weight(.bold))
                .foregroundStyle(Theme.textPrimary)
            Text("This case's Time Attack board ships with a future update. Times posted before then won't appear on the global ranking.")
                .font(.system(.subheadline, design: .serif).italic())
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity)
        .glassCard(corner: 16)
    }

    // MARK: - Case picker

    private var casePicker: some View {
        Button {
            Haptics.tap()
            showCasePicker = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: selectedCase.sceneTint[0], green: selectedCase.sceneTint[1], blue: selectedCase.sceneTint[2]),
                                    Color(red: selectedCase.sceneTint[0] * 0.5, green: selectedCase.sceneTint[1] * 0.5, blue: selectedCase.sceneTint[2] * 0.5)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: selectedCase.sceneIcon)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white.opacity(0.92))
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 2) {
                    Text("CASE")
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(Theme.textMuted)
                    Text(selectedCase.title)
                        .font(.system(.headline, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.textMuted)
            }
            .padding(12)
            .glassCard(corner: 14)
        }
        .buttonStyle(PressableButtonStyle())
    }

    private var casePickerSheet: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("PICK A CASE")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(Theme.gold)
                    .padding(.top, 18)

                ForEach(CaseRepository.allCases) { c in
                    Button {
                        Haptics.tap()
                        selectedCase = c
                        showCasePicker = false
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: c.sceneTint[0], green: c.sceneTint[1], blue: c.sceneTint[2]),
                                                Color(red: c.sceneTint[0] * 0.5, green: c.sceneTint[1] * 0.5, blue: c.sceneTint[2] * 0.5)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                Image(systemName: c.sceneIcon)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 44, height: 44)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(c.difficulty.displayName)
                                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                                    .tracking(1.4)
                                    .foregroundStyle(c.difficulty.tintColor)
                                Text(c.title)
                                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                                    .foregroundStyle(Theme.textPrimary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            if c.id == selectedCase.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Theme.gold)
                            }
                        }
                        .padding(10)
                        .glassCard(corner: 12)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Attempt button

    private var isCaseUnlocked: Bool {
        game.isUnlocked(selectedCase)
    }

    private var lockedReason: String? {
        guard !isCaseUnlocked else { return nil }
        if let reqId = selectedCase.requiresCaseId,
           !game.profile.solvedCaseIds.contains(reqId),
           let prereq = CaseRepository.byId(reqId) {
            return "Solve \"\(prereq.title)\" first"
        }
        if selectedCase.unlockCost > 0,
           game.profile.fingerprints < selectedCase.unlockCost {
            return "Costs \(selectedCase.unlockCost) fp to unlock"
        }
        return "Locked"
    }

    @ViewBuilder
    private var attemptButton: some View {
        let locked = !isCaseUnlocked
        let solved = game.profile.solvedCaseIds.contains(selectedCase.id)
        let title = solved ? "Improve Your Time" : "Attempt This Case"
        let icon = solved ? "stopwatch.fill" : "play.fill"

        Button {
            guard !locked else {
                Haptics.failure()
                return
            }
            Haptics.tap()
            path.append(AppRoute.intro(caseId: selectedCase.id))
        } label: {
            HStack(spacing: 10) {
                Image(systemName: locked ? "lock.fill" : icon)
                    .font(.system(size: 14, weight: .heavy))
                Text(locked ? (lockedReason ?? "Locked") : title)
                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                Spacer()
                if !locked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .heavy))
                }
            }
            .foregroundStyle(locked ? Theme.textMuted : Theme.midnight)
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(locked ? Theme.coal.opacity(0.6) : Theme.gold)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(locked ? Theme.textMuted.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(locked)
    }

    // MARK: - Scope picker

    private var scopePicker: some View {
        HStack(spacing: 0) {
            scopeChip(label: "FRIENDS", icon: "person.2.fill", value: .friends)
            scopeChip(label: "GLOBAL", icon: "globe", value: .global)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.coal.opacity(0.6))
        )
    }

    private func scopeChip(label: String, icon: String, value: GameCenterManager.LeaderboardScope) -> some View {
        let active = scope == value
        return Button {
            Haptics.tap()
            scope = value
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                Text(label)
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(1.6)
            }
            .foregroundStyle(active ? Theme.midnight : Theme.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .fill(active ? Theme.gold : Color.clear)
            )
        }
        .buttonStyle(PressableButtonStyle())
    }

    // MARK: - Leaderboard body

    @ViewBuilder
    private var leaderboardBody: some View {
        if loading {
            ProgressView()
                .tint(Theme.gold)
                .frame(maxWidth: .infinity, minHeight: 200)
                .glassCard(corner: 16)
        } else if let err = loadError {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(Theme.bloodRed)
                Text("Couldn't load leaderboard")
                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(err)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Theme.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
            }
            .padding(20)
            .glassCard(corner: 16)
        } else if let snap = snapshot {
            VStack(spacing: 12) {
                if let local = snap.localPlayer {
                    EntryRow(entry: local, accent: true, label: "YOUR BEST")
                }

                if snap.topEntries.isEmpty {
                    VStack(spacing: 6) {
                        Image(systemName: "moon.zzz.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(Theme.textMuted)
                        Text(scope == .friends
                             ? "No friends have posted a time yet."
                             : "No one has posted a time yet.")
                            .font(.system(.subheadline, design: .serif).italic())
                            .foregroundStyle(Theme.textMuted)
                            .multilineTextAlignment(.center)
                        Text(scope == .friends
                             ? "Invite a friend, or be the first."
                             : "Be the first.")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.gold)
                    }
                    .padding(28)
                    .glassCard(corner: 14)
                } else {
                    ForEach(snap.topEntries) { entry in
                        EntryRow(entry: entry, accent: entry.isLocalPlayer, label: nil)
                    }
                }

                if snap.totalCount > snap.topEntries.count {
                    Text("\(snap.totalCount - snap.topEntries.count) more not shown")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textMuted)
                        .padding(.top, 6)
                }
            }
        }
    }

    // MARK: - Loading

    private var scopeKey: String { "\(selectedCase.id)|\(scope == .friends ? "f" : "g")" }

    private func loadSnapshot() async {
        guard gc.isAuthenticated else { return }
        loading = true
        loadError = nil
        defer { loading = false }
        do {
            snapshot = try await gc.loadLeaderboard(caseId: selectedCase.id, scope: scope)
        } catch {
            loadError = error.localizedDescription
            snapshot = nil
        }
    }
}

private struct EntryRow: View {
    let entry: GameCenterManager.Entry
    let accent: Bool
    let label: String?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill((accent ? Theme.gold : Theme.smoke).opacity(0.22))
                    .frame(width: 38, height: 38)
                Text("\(entry.rank)")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(accent ? Theme.gold : Theme.textPrimary)
                    .monospacedDigit()
            }

            VStack(alignment: .leading, spacing: 2) {
                if let label {
                    Text(label)
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .tracking(1.6)
                        .foregroundStyle(Theme.gold)
                }
                Text(entry.displayName.isEmpty ? "Anonymous" : entry.displayName)
                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                if entry.isLocalPlayer && label == nil {
                    Text("YOU")
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .tracking(1.4)
                        .foregroundStyle(Theme.midnight)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Theme.gold)
                        .clipShape(Capsule())
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(CaseTimer.format(milliseconds: entry.milliseconds))
                    .font(.system(size: 16, weight: .heavy, design: .monospaced))
                    .foregroundStyle(accent ? Theme.gold : Theme.textPrimary)
                    .monospacedDigit()
                Text("TIME")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(1.4)
                    .foregroundStyle(Theme.textMuted)
            }
        }
        .padding(12)
        .glassCard(corner: 14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(accent ? Theme.gold.opacity(0.6) : Color.clear, lineWidth: 1)
        )
    }
}
