import SwiftUI

struct CourtroomView: View {
    static let maxSubmissions: Int = 3

    let crimeCase: CrimeCase
    let collectedEvidence: [Evidence]
    @Binding var path: NavigationPath
    @EnvironmentObject var game: GameStateManager
    @Environment(\.dismiss) private var dismiss

    @State private var selected: Set<String> = []
    @State private var showConfirm = false
    @State private var inspecting: Evidence?

    private var atSelectionCap: Bool {
        selected.count >= Self.maxSubmissions
    }

    var body: some View {
        ZStack {
            NoirBackground(tint: Color(red: 0.30, green: 0.16, blue: 0.10))

            VStack(spacing: 14) {
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
                    Text("COURTROOM")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(3)
                        .foregroundStyle(Theme.gold)
                    Spacer()
                    CaseTimerHUD()
                        .frame(minWidth: 36, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                // Judge plate
                JudgePlate()
                    .padding(.horizontal, 16)

                // Instruction
                VStack(spacing: 6) {
                    Text(crimeCase.title)
                        .font(.system(.title3, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Submit 1 to \(Self.maxSubmissions) exhibits. Choose carefully — the bench has no patience for chaff.")
                        .font(.system(.subheadline, design: .serif).italic())
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                // Evidence list
                if collectedEvidence.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.system(size: 30))
                            .foregroundStyle(Theme.textMuted)
                        Text("You collected no evidence.")
                            .font(.system(.subheadline, design: .serif).italic())
                            .foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(collectedEvidence) { ev in
                                let isSelected = selected.contains(ev.id)
                                let lockedOut = !isSelected && atSelectionCap
                                CourtEvidenceRow(
                                    evidence: ev,
                                    selected: isSelected,
                                    onToggle: {
                                        if isSelected {
                                            Haptics.tap()
                                            selected.remove(ev.id)
                                        } else if !atSelectionCap {
                                            Haptics.tap()
                                            selected.insert(ev.id)
                                        } else {
                                            Haptics.failure()
                                        }
                                    },
                                    onInspect: {
                                        Haptics.tap()
                                        inspecting = ev
                                    }
                                )
                                .opacity(lockedOut ? 0.45 : 1.0)
                            }

                            Text("Tap the magnifier to review what your analyses revealed.")
                                .font(.system(.caption, design: .serif).italic())
                                .foregroundStyle(Theme.textMuted)
                                .padding(.top, 6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }

                // Bottom action
                VStack(spacing: 8) {
                    HStack {
                        Text("\(selected.count) of \(Self.maxSubmissions) selected")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(atSelectionCap ? Theme.gold : Theme.textSecondary)
                        Spacer()
                        Text("Min: \(crimeCase.minIncriminatingToWin) incriminating")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.gold)
                    }
                    .padding(.horizontal, 4)

                    PrimaryButton(
                        title: "Submit to Judge",
                        systemImage: "hammer.fill",
                        style: .gold,
                        isEnabled: !selected.isEmpty
                    ) {
                        showConfirm = true
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $inspecting) { ev in
            EvidenceInspectSheet(
                evidence: ev,
                mode: .review,
                onDismiss: { inspecting = nil }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationBackground(Theme.ink)
        }
        .alert("Submit these exhibits?", isPresented: $showConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Submit", role: .destructive) {
                deliverVerdict()
            }
        } message: {
            Text("The bench will rule on what you've selected. There is no take-backs.")
        }
    }

    private func deliverVerdict() {
        let presented = collectedEvidence.filter { selected.contains($0.id) }
        let baseResult = JudgeService.evaluate(crimeCase: crimeCase, presented: presented)
        let adjustedReward = Int(Double(baseResult.reward) * game.rewardMultiplier)
        let adjustedFine = Int(Double(baseResult.fine) * game.fineMultiplier)

        // Stop the run timer the moment the bench rules. Only submit on a guilty verdict —
        // a not-guilty doesn't represent a real "completion" of the case.
        let stopped = CaseTimer.shared.stop()
        let runMs: Int? = (baseResult.isGuilty ? stopped?.milliseconds : nil)

        let result = VerdictResult(
            caseId: baseResult.caseId,
            isGuilty: baseResult.isGuilty,
            reward: adjustedReward,
            fine: adjustedFine,
            presentedIncriminating: baseResult.presentedIncriminating,
            presentedRedHerrings: baseResult.presentedRedHerrings,
            requiredIncriminating: baseResult.requiredIncriminating,
            summary: baseResult.summary,
            submittedEvidence: baseResult.submittedEvidence,
            caseTimeMilliseconds: runMs
        )
        game.recordVerdict(result)
        CrimeSceneSession.shared.lastVerdict = result
        if result.isGuilty {
            Haptics.success()
            if let ms = runMs {
                Task {
                    await GameCenterManager.shared.submitTime(caseId: result.caseId, milliseconds: ms)
                }
            }
        } else {
            Haptics.failure()
        }
        path.append(AppRoute.verdict(
            caseId: crimeCase.id,
            isGuilty: result.isGuilty,
            reward: result.reward,
            fine: result.fine
        ))
    }
}

private struct CourtEvidenceRow: View {
    let evidence: Evidence
    let selected: Bool
    let onToggle: () -> Void
    let onInspect: () -> Void

    @ObservedObject private var session = CrimeSceneSession.shared

    private var revealedCount: Int {
        session.revealedTools(for: evidence.id).count
    }

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onToggle) {
                EvidenceChip(evidence: evidence, selected: selected)
            }
            .buttonStyle(PressableButtonStyle())

            Button(action: onInspect) {
                ZStack {
                    Circle()
                        .fill(Theme.gold.opacity(revealedCount > 0 ? 0.18 : 0.08))
                        .frame(width: 38, height: 38)
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(revealedCount > 0 ? Theme.gold : Theme.textSecondary)
                }
                .overlay(alignment: .topTrailing) {
                    if revealedCount > 0 {
                        Text("\(revealedCount)")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundStyle(Theme.midnight)
                            .padding(.horizontal, 4).padding(.vertical, 1)
                            .background(Theme.gold)
                            .clipShape(Capsule())
                            .offset(x: 6, y: -4)
                    }
                }
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
}

private struct JudgePlate: View {
    @State private var glow = false
    var body: some View {
        ZStack {
            // Wood backdrop
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.18, blue: 0.10),
                            Color(red: 0.10, green: 0.06, blue: 0.04)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 130)

            // Lamp glow
            RadialGradient(
                colors: [Theme.gold.opacity(glow ? 0.45 : 0.30), .clear],
                center: UnitPoint(x: 0.5, y: 0.0),
                startRadius: 0,
                endRadius: 280
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: glow)

            // Judge silhouette + scales
            HStack(spacing: 18) {
                Image(systemName: "person.fill")
                    .font(.system(size: 56, weight: .black))
                    .foregroundStyle(.black.opacity(0.85))
                    .overlay(
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.black.opacity(0.95))
                            .offset(y: -22)
                    )
                Image(systemName: "scale.3d")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(Theme.gold)
                    .shadow(color: Theme.gold.opacity(0.5), radius: 8)
                Image(systemName: "hammer.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(red: 0.55, green: 0.30, blue: 0.16))
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.gold.opacity(0.4), lineWidth: 1)
        )
        .onAppear { glow = true }
    }
}
