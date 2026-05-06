import SwiftUI

struct CrimeSceneView: View {
    let crimeCase: CrimeCase
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var game: GameStateManager

    @State private var collected: Set<String> = []
    @State private var revealed: Set<String> = []
    @State private var roomEvidence: Evidence?
    @State private var inventoryInspect: Evidence?
    @State private var showInventory = false
    @State private var lensPosition: CGPoint = .zero
    @State private var sceneSize: CGSize = .zero
    @State private var didApplyPrereveal = false

    private var collectedEvidence: [Evidence] {
        crimeCase.evidence.filter { collected.contains($0.id) }
    }

    var body: some View {
        ZStack {
            NoirBackground()

            VStack(spacing: 12) {
                // Top bar
                HStack(spacing: 10) {
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

                    VStack(alignment: .leading, spacing: 1) {
                        Text(crimeCase.location.uppercased())
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .tracking(1.6)
                            .foregroundStyle(Theme.gold)
                            .lineLimit(1)
                        Text("Search the scene")
                            .font(.system(.subheadline, design: .serif).weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                    }
                    Spacer()
                    CaseTimerHUD()
                    EvidenceProgress(collected: collected.count, total: crimeCase.evidence.count)
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                // Scene canvas
                GeometryReader { geo in
                    ZStack {
                        SceneArtwork(crimeCase: crimeCase)

                        // Hint sparkles for unrevealed evidence
                        ForEach(crimeCase.evidence) { ev in
                            if !collected.contains(ev.id) {
                                EvidenceTarget(
                                    evidence: ev,
                                    revealed: revealed.contains(ev.id),
                                    incriminatingHint: game.hintsIncriminatingSparkles && ev.isIncriminating,
                                    onReveal: {
                                        Haptics.collect()
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            revealed.insert(ev.id)
                                            roomEvidence = ev
                                        }
                                    }
                                )
                                .position(
                                    x: ev.position.x * geo.size.width,
                                    y: ev.position.y * geo.size.height
                                )
                            }
                        }
                    }
                    .onAppear {
                        sceneSize = geo.size
                        applyPrereveal()
                        CaseTimer.shared.start(caseId: crimeCase.id)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22).strokeBorder(.white.opacity(0.10), lineWidth: 1)
                )
                .padding(.horizontal, 16)

                // Bottom bar
                HStack(spacing: 12) {
                    PrimaryButton(
                        title: "Inventory · \(collected.count)",
                        systemImage: "bag.fill",
                        style: .ghost
                    ) {
                        showInventory = true
                    }

                    PrimaryButton(
                        title: "Present to Court",
                        systemImage: "scale.3d",
                        style: .gold,
                        isEnabled: collectedEvidence.count >= 1
                    ) {
                        CrimeSceneSession.shared.record(
                            caseId: crimeCase.id,
                            evidence: collectedEvidence
                        )
                        path.append(AppRoute.courtroom(caseId: crimeCase.id))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(item: $roomEvidence) { ev in
            EvidenceRoomView(
                evidence: ev,
                alreadyCollected: collected.contains(ev.id),
                onCollect: {
                    Haptics.success()
                    withAnimation(.spring(response: 0.5)) {
                        collected.insert(ev.id)
                    }
                    roomEvidence = nil
                },
                onDismiss: {
                    roomEvidence = nil
                }
            )
        }
        .sheet(item: $inventoryInspect) { ev in
            EvidenceInspectSheet(
                evidence: ev,
                mode: .review,
                onDismiss: { inventoryInspect = nil }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationBackground(Theme.ink)
        }
        .sheet(isPresented: $showInventory) {
            InventorySheet(
                evidence: collectedEvidence,
                allCount: crimeCase.evidence.count,
                showsPolaroid: game.showsPolaroidBadge,
                onTapEvidence: { ev in
                    showInventory = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        inventoryInspect = ev
                    }
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationBackground(Theme.ink)
        }
    }

    /// Pre-reveals N sparkles based on owned assistants (Rookie + Tail).
    /// Prefers incriminating pieces first for narrative coherence.
    private func applyPrereveal() {
        guard !didApplyPrereveal else { return }
        didApplyPrereveal = true
        let count = game.prerevealedSparkleCount
        guard count > 0 else { return }
        let ordered = crimeCase.evidence.sorted { lhs, rhs in
            // Incriminating first, then by id
            if lhs.isIncriminating != rhs.isIncriminating { return lhs.isIncriminating }
            return lhs.id < rhs.id
        }
        for ev in ordered.prefix(count) {
            revealed.insert(ev.id)
        }
    }
}

// MARK: - Evidence target

private struct EvidenceTarget: View {
    let evidence: Evidence
    let revealed: Bool
    let incriminatingHint: Bool
    let onReveal: () -> Void
    @State private var pulse = false

    var body: some View {
        Button(action: onReveal) {
            ZStack {
                if !revealed {
                    // Subtle sparkle / hotspot indicator
                    let hintColor = incriminatingHint ? Theme.gold : Color(white: 0.85)
                    let glowColor = incriminatingHint ? Theme.gold : Color(white: 0.85)
                    Circle()
                        .fill(glowColor.opacity(incriminatingHint ? 0.22 : 0.10))
                        .frame(width: pulse ? 44 : 32, height: pulse ? 44 : 32)
                    Circle()
                        .strokeBorder(hintColor.opacity(incriminatingHint ? 0.85 : 0.45), lineWidth: incriminatingHint ? 1.5 : 1)
                        .frame(width: 28, height: 28)
                    Image(systemName: incriminatingHint ? "exclamationmark.triangle.fill" : "sparkle")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(hintColor)
                        .opacity(pulse ? 1 : 0.5)
                } else {
                    // Revealed evidence icon (still collectible)
                    ZStack {
                        Circle()
                            .fill(evidence.type.tintColor.opacity(0.18))
                            .frame(width: 44, height: 44)
                        Circle()
                            .strokeBorder(evidence.type.tintColor, lineWidth: 1.5)
                            .frame(width: 36, height: 36)
                        Image(systemName: evidence.type.iconName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(evidence.type.tintColor)
                    }
                }
            }
            .frame(width: 56, height: 56)
            .contentShape(Circle())
        }
        .buttonStyle(PressableButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

// MARK: - Scene artwork (procedural / SF symbol composed)

private struct SceneArtwork: View {
    let crimeCase: CrimeCase
    @State private var spotlight = false

    var body: some View {
        ZStack {
            // Floor / wall
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [
                        Color(red: crimeCase.sceneTint[0], green: crimeCase.sceneTint[1], blue: crimeCase.sceneTint[2]),
                        Color(red: crimeCase.sceneTint[0] * 0.4, green: crimeCase.sceneTint[1] * 0.4, blue: crimeCase.sceneTint[2] * 0.4)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxHeight: .infinity)

                LinearGradient(
                    colors: [
                        Color(red: 0.12, green: 0.08, blue: 0.10),
                        Color(red: 0.05, green: 0.03, blue: 0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
            }

            // Big silhouetted scene icon (low contrast, atmospheric)
            Image(systemName: crimeCase.sceneIcon)
                .font(.system(size: 220, weight: .bold))
                .foregroundStyle(.black.opacity(0.4))
                .blur(radius: 0.5)
                .offset(y: -10)

            // Roving spotlight
            RadialGradient(
                colors: [Theme.gold.opacity(spotlight ? 0.20 : 0.10), .clear],
                center: UnitPoint(x: spotlight ? 0.7 : 0.3, y: 0.4),
                startRadius: 0,
                endRadius: 220
            )
            .blendMode(.screen)
            .animation(.easeInOut(duration: 4.5).repeatForever(autoreverses: true), value: spotlight)

            // Vignette
            RadialGradient(
                colors: [.clear, .black.opacity(0.6)],
                center: .center,
                startRadius: 100,
                endRadius: 360
            )
        }
        .onAppear { spotlight = true }
    }
}

// MARK: - Inventory sheet

private struct InventorySheet: View {
    let evidence: [Evidence]
    let allCount: Int
    let showsPolaroid: Bool
    let onTapEvidence: (Evidence) -> Void

    var body: some View {
        ZStack {
            NoirBackground()
            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EVIDENCE BAG")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .tracking(2)
                            .foregroundStyle(Theme.gold)
                        Text("\(evidence.count) of \(allCount) collected")
                            .font(.system(.title3, design: .serif).weight(.semibold))
                            .foregroundStyle(Theme.textPrimary)
                    }
                    Spacer()
                    Image(systemName: "bag.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Theme.gold)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)

                if evidence.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 36))
                            .foregroundStyle(Theme.textMuted)
                        Text("Nothing collected yet")
                            .font(.system(.subheadline, design: .serif).italic())
                            .foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(evidence) { ev in
                                Button {
                                    Haptics.tap()
                                    onTapEvidence(ev)
                                } label: {
                                    HStack(spacing: 0) {
                                        EvidenceChip(evidence: ev, showsPolaroid: showsPolaroid)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .heavy))
                                            .foregroundStyle(Theme.textMuted)
                                            .padding(.trailing, 12)
                                    }
                                }
                                .buttonStyle(PressableButtonStyle())
                            }

                            Text("Tap a piece to inspect or run analyses.")
                                .font(.system(.caption, design: .serif).italic())
                                .foregroundStyle(Theme.textMuted)
                                .padding(.top, 6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
    }
}

// MARK: - Progress

private struct EvidenceProgress: View {
    let collected: Int
    let total: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(Theme.gold)
            Text("\(collected)/\(total)")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
                .monospacedDigit()
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .glassCard(corner: 12)
    }
}
