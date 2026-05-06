import SwiftUI

struct EvidenceInspectSheet: View {
    enum Mode {
        case discovery   // first time, on the scene — Leave it / Collect
        case review      // after collected — read & analyze
    }

    let evidence: Evidence
    let mode: Mode
    var onCollect: (() -> Void)? = nil
    var onDismiss: () -> Void

    @EnvironmentObject var game: GameStateManager
    @ObservedObject private var session = CrimeSceneSession.shared
    @State private var runningTool: AnalysisTool?

    var body: some View {
        ZStack {
            NoirBackground(tint: evidence.type.tintColor.opacity(0.5))

            ScrollView {
                VStack(spacing: 16) {
                    EvidenceHero(evidence: evidence)
                        .padding(.top, 12)

                    Text(evidence.description)
                        .font(.system(.body, design: .serif).italic())
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 22)

                    if evidence.analysis != nil {
                        AnalysisSection(
                            evidence: evidence,
                            runningTool: $runningTool,
                            onRun: { tool in
                                runAnalysis(tool: tool)
                            }
                        )
                        .padding(.horizontal, 16)
                    }

                    actionRow
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
    }

    private var actionRow: some View {
        Group {
            switch mode {
            case .discovery:
                HStack(spacing: 10) {
                    PrimaryButton(title: "Leave it", style: .ghost) {
                        onDismiss()
                    }
                    PrimaryButton(
                        title: "Collect",
                        systemImage: "tray.and.arrow.down.fill",
                        style: .gold
                    ) {
                        onCollect?()
                    }
                }
            case .review:
                PrimaryButton(title: "Done", style: .gold) {
                    onDismiss()
                }
            }
        }
    }

    private func runAnalysis(tool: AnalysisTool) {
        Haptics.collect()
        runningTool = tool
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                session.markRevealed(tool, for: evidence.id)
                runningTool = nil
            }
            Haptics.success()
        }
    }
}

// MARK: - Hero

private struct EvidenceHero: View {
    let evidence: Evidence

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(evidence.type.tintColor.opacity(0.18))
                    .frame(width: 110, height: 110)
                Circle()
                    .strokeBorder(evidence.type.tintColor, lineWidth: 2)
                    .frame(width: 90, height: 90)
                Image(systemName: evidence.type.iconName)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(evidence.type.tintColor)
            }

            VStack(spacing: 4) {
                Text(evidence.type.displayName.uppercased())
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(evidence.type.tintColor)
                Text(evidence.name)
                    .font(.system(.title2, design: .serif).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Analysis section

private struct AnalysisSection: View {
    let evidence: Evidence
    @Binding var runningTool: AnalysisTool?
    let onRun: (AnalysisTool) -> Void

    @EnvironmentObject var game: GameStateManager
    @ObservedObject private var session = CrimeSceneSession.shared

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("ANALYSIS")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(Theme.gold)
                Spacer()
                let revealedCount = session.revealedTools(for: evidence.id).count
                Text("\(revealedCount) of \(AnalysisTool.allCases.count) run")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textMuted)
            }
            .padding(.horizontal, 4)

            VStack(spacing: 8) {
                ForEach(AnalysisTool.allCases) { tool in
                    AnalysisRow(
                        evidence: evidence,
                        tool: tool,
                        running: runningTool == tool,
                        anyRunning: runningTool != nil,
                        onRun: { onRun(tool) }
                    )
                }
            }

            // Forensic verdict (only when forensic assistant has revealed it)
            if session.hasRevealed(.forensicAssistant, for: evidence.id),
               let analysis = evidence.analysis {
                ForensicVerdictBanner(strength: analysis.forensicVerdict)
                    .padding(.top, 4)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

private struct AnalysisRow: View {
    let evidence: Evidence
    let tool: AnalysisTool
    let running: Bool
    let anyRunning: Bool
    let onRun: () -> Void

    @EnvironmentObject var game: GameStateManager
    @ObservedObject private var session = CrimeSceneSession.shared

    private var owned: Bool { game.hasAnalysisTool(tool) }
    private var revealed: Bool { session.hasRevealed(tool, for: evidence.id) }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tool.tintColor.opacity(owned ? 0.22 : 0.08))
                        .frame(width: 40, height: 40)
                    Image(systemName: tool.iconName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(owned ? tool.tintColor : Theme.textMuted)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(tool.displayName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    if let item = game.shopItem(forAnalysisTool: tool), !owned {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 9, weight: .heavy))
                            Text("Requires \(item.name) · \(item.price)")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(Theme.textMuted)
                    } else if running {
                        Text("Analyzing…")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundStyle(tool.tintColor)
                    } else if revealed {
                        Text("Reading complete")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .tracking(1.2)
                            .foregroundStyle(Theme.gold)
                    } else {
                        Text("Ready to run")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .tracking(1.2)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }

                Spacer()

                if owned && !revealed {
                    Button(action: { Haptics.tap(); onRun() }) {
                        HStack(spacing: 4) {
                            if running {
                                ProgressView().tint(Theme.midnight).scaleEffect(0.7)
                            } else {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 11, weight: .heavy))
                                Text("RUN")
                                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                                    .tracking(1.2)
                            }
                        }
                        .foregroundStyle(Theme.midnight)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Theme.goldGradient)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(anyRunning)
                    .opacity(anyRunning && !running ? 0.5 : 1.0)
                }
            }

            // Finding text — appears below row once revealed
            if revealed {
                let displayText = game.displayFinding(for: tool, evidence: evidence)
                Divider()
                    .background(tool.tintColor.opacity(0.25))
                    .padding(.top, 10)

                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(tool.tintColor.opacity(0.7))
                    Text(displayText)
                        .font(.system(.footnote, design: .serif).italic())
                        .foregroundStyle(Theme.textPrimary.opacity(0.92))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 8)
            }
        }
        .padding(12)
        .glassCard(corner: 12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    revealed ? tool.tintColor.opacity(0.45) : Color.clear,
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Forensic verdict banner

private struct ForensicVerdictBanner: View {
    let strength: AnalysisStrength

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(strength.tintColor.opacity(0.20))
                    .frame(width: 44, height: 44)
                Image(systemName: strength.iconName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(strength.tintColor)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("FORENSIC VERDICT")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(Theme.textMuted)
                Text(strength.displayName)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .tracking(0.6)
                    .foregroundStyle(strength.tintColor)
                Text(strength.subtitle)
                    .font(.system(.caption, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(12)
        .glassCard(corner: 14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(strength.tintColor.opacity(0.6), lineWidth: 1)
        )
    }
}
