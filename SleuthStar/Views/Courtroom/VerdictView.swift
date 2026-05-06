import SwiftUI

struct VerdictView: View {
    let crimeCase: CrimeCase
    let isGuilty: Bool
    let reward: Int
    let fine: Int
    @Binding var path: NavigationPath

    @ObservedObject private var session = CrimeSceneSession.shared
    @State private var phase: VerdictPhase = .opening
    @State private var reviewIndex: Int = 0

    private var accent: Color {
        isGuilty ? Theme.leafGreen : Theme.bloodRed
    }

    private var submitted: [Evidence] {
        session.lastVerdict?.submittedEvidence ?? []
    }

    var body: some View {
        ZStack {
            NoirBackground(tint: accent.opacity(0.6))

            // Phase content
            Group {
                switch phase {
                case .opening:
                    OpeningView()
                        .transition(.opacity)
                case .review:
                    if reviewIndex < submitted.count {
                        ReviewExhibitView(
                            evidence: submitted[reviewIndex],
                            indexLabel: "Exhibit \(reviewIndex + 1) of \(submitted.count)",
                            isLast: reviewIndex + 1 == submitted.count,
                            onNext: { advanceReview() }
                        )
                        .id(submitted[reviewIndex].id)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                case .narrative:
                    NarrativeView(crimeCase: crimeCase)
                        .transition(.opacity)
                case .ruling:
                    RulingView(isGuilty: isGuilty, summary: session.lastVerdict?.summary ?? "")
                        .transition(.scale.combined(with: .opacity))
                case .payout:
                    PayoutView(
                        crimeCase: crimeCase,
                        isGuilty: isGuilty,
                        reward: reward,
                        fine: fine,
                        path: $path
                    )
                    .transition(.opacity)
                }
            }

            // Skip pill (always present except final payout)
            if phase != .payout {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            Haptics.tap()
                            advanceToFinal()
                        } label: {
                            HStack(spacing: 6) {
                                Text("SKIP")
                                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                                    .tracking(2)
                                Image(systemName: "forward.fill")
                                    .font(.system(size: 11, weight: .heavy))
                            }
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(.ultraThinMaterial.opacity(0.5))
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(.white.opacity(0.3), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear { runSequence() }
    }

    // MARK: - Sequence orchestration

    private func runSequence() {
        // Opening (1.4s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            advanceFromOpening()
        }
    }

    private func advanceFromOpening() {
        guard phase == .opening else { return }
        if submitted.isEmpty {
            withAnimation(.easeInOut(duration: 0.5)) {
                phase = isGuilty ? .narrative : .ruling
            }
            scheduleNext()
        } else {
            reviewIndex = 0
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) {
                phase = .review
            }
            Haptics.tap()
        }
    }

    private func advanceReview() {
        guard phase == .review else { return }
        if reviewIndex + 1 < submitted.count {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                reviewIndex += 1
            }
            Haptics.tap()
        } else {
            // Move past review
            withAnimation(.easeInOut(duration: 0.55)) {
                phase = isGuilty ? .narrative : .ruling
            }
            scheduleNext()
        }
    }

    private func scheduleNext() {
        if phase == .narrative {
            // Narrative duration scales with truth length
            let lines = max(1, crimeCase.truth.count)
            let duration = 1.4 + Double(lines) * 1.4
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                guard phase == .narrative else { return }
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                    phase = .ruling
                }
                Haptics.success()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                    guard phase == .ruling else { return }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        phase = .payout
                    }
                }
            }
        } else if phase == .ruling {
            if isGuilty {
                Haptics.success()
            } else {
                Haptics.failure()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                guard phase == .ruling else { return }
                withAnimation(.easeInOut(duration: 0.5)) {
                    phase = .payout
                }
            }
        }
    }

    private func advanceToFinal() {
        withAnimation(.easeInOut(duration: 0.4)) {
            phase = .payout
        }
        if isGuilty {
            Haptics.success()
        } else {
            Haptics.failure()
        }
    }
}

enum VerdictPhase {
    case opening
    case review
    case narrative
    case ruling
    case payout
}

// MARK: - Opening

private struct OpeningView: View {
    @State private var glow = false

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            // Bench/lamp icon glow
            ZStack {
                Circle()
                    .fill(Theme.gold.opacity(glow ? 0.30 : 0.12))
                    .frame(width: 220, height: 220)
                    .blur(radius: 30)
                    .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: glow)
                Image(systemName: "scale.3d")
                    .font(.system(size: 90, weight: .bold))
                    .foregroundStyle(Theme.gold)
                    .shadow(color: Theme.gold.opacity(0.7), radius: 14)
            }

            VStack(spacing: 8) {
                Text("THE BENCH WILL")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .tracking(4)
                    .foregroundStyle(Theme.gold.opacity(0.8))
                Text("Review the Exhibits")
                    .font(.system(.title, design: .serif).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
            }

            Spacer()
        }
        .onAppear { glow = true }
    }
}

// MARK: - Review (per-exhibit)

private struct ReviewExhibitView: View {
    let evidence: Evidence
    let indexLabel: String
    let isLast: Bool
    let onNext: () -> Void

    @State private var stampShown = false
    @State private var lineRevealed = false

    private var accepted: Bool { evidence.isIncriminating }

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 40)

            Text(indexLabel.uppercased())
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .tracking(2.4)
                .foregroundStyle(Theme.gold.opacity(0.85))

            // Exhibit card (parchment style)
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.96, green: 0.91, blue: 0.79),
                                Color(red: 0.86, green: 0.78, blue: 0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.55), radius: 16, x: 0, y: 8)

                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(evidence.type.tintColor.opacity(0.22))
                            .frame(width: 84, height: 84)
                        Circle()
                            .strokeBorder(evidence.type.tintColor, lineWidth: 1.5)
                            .frame(width: 70, height: 70)
                        Image(systemName: evidence.type.iconName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(evidence.type.tintColor)
                    }

                    Text(evidence.type.displayName.uppercased())
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(Theme.midnight.opacity(0.6))

                    Text(evidence.name)
                        .font(.system(.title3, design: .serif).weight(.bold))
                        .foregroundStyle(Theme.midnight)
                        .multilineTextAlignment(.center)

                    Text(evidence.surfaceLabel)
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .tracking(1.5)
                        .foregroundStyle(Theme.midnight.opacity(0.55))
                }
                .padding(20)

                // Stamp overlay
                if stampShown {
                    StampView(accepted: accepted)
                        .rotationEffect(.degrees(accepted ? -12 : 14))
                        .offset(x: accepted ? -28 : 32, y: -84)
                        .transition(.scale(scale: 2.4).combined(with: .opacity))
                }
            }
            .frame(width: 270, height: 320)

            // Judge's line
            Group {
                if lineRevealed {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Theme.gold.opacity(0.7))
                            .padding(.top, 4)
                        Text(evidence.judgeLine)
                            .font(.system(.body, design: .serif).italic())
                            .foregroundStyle(Theme.textPrimary.opacity(0.94))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(14)
                    .glassCard(corner: 14)
                    .padding(.horizontal, 20)
                    .transition(.opacity.combined(with: .offset(y: 12)))
                }
            }
            .frame(height: 90)

            Spacer(minLength: 12)

            PrimaryButton(
                title: isLast ? "Deliver Verdict" : "Next Exhibit",
                systemImage: isLast ? "checkmark.seal.fill" : "arrow.right",
                style: .gold
            ) {
                Haptics.tap()
                onNext()
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 28)
            .opacity(lineRevealed ? 1 : 0)
            .animation(.easeOut(duration: 0.4), value: lineRevealed)
            .allowsHitTesting(lineRevealed)
        }
        .onAppear {
            // Stamp first, then line
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.55)) {
                    stampShown = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    lineRevealed = true
                }
            }
        }
    }
}

private struct StampView: View {
    let accepted: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .strokeBorder(stampColor, lineWidth: 4)
                .frame(width: 130, height: 50)
            Text(accepted ? "ACCEPTED" : "DISCARDED")
                .font(.system(size: 17, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundStyle(stampColor)
        }
        .opacity(0.85)
        .blur(radius: 0.4)
        .shadow(color: stampColor.opacity(0.4), radius: 4)
    }

    private var stampColor: Color {
        accepted ? Color(red: 0.10, green: 0.45, blue: 0.20) : Color(red: 0.66, green: 0.14, blue: 0.14)
    }
}

// MARK: - Narrative (truth reveal)

private struct NarrativeView: View {
    let crimeCase: CrimeCase
    @State private var visibleLines: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 30)

            VStack(spacing: 4) {
                Text("WHAT HAPPENED")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(3)
                    .foregroundStyle(Theme.gold)
                Text(crimeCase.location)
                    .font(.system(.subheadline, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
            }

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(crimeCase.truth.enumerated()), id: \.offset) { idx, line in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Theme.gold)
                            .frame(width: 7, height: 7)
                            .padding(.top, 9)
                            .opacity(idx < visibleLines ? 1 : 0)
                        Text(line)
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Theme.textPrimary.opacity(idx < visibleLines ? 0.96 : 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: idx < visibleLines ? 0 : 10)
                    }
                }
            }
            .padding(18)
            .glassCard(corner: 16)
            .padding(.horizontal, 18)

            Spacer(minLength: 40)
        }
        .onAppear {
            for i in 0..<crimeCase.truth.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + Double(i) * 1.2) {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) {
                        visibleLines = i + 1
                    }
                    Haptics.tap()
                }
            }
        }
    }
}

// MARK: - Ruling

private struct RulingView: View {
    let isGuilty: Bool
    let summary: String

    @State private var hammerStrike = false
    @State private var revealText = false

    private var accent: Color {
        isGuilty ? Theme.leafGreen : Theme.bloodRed
    }

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            Text("VERDICT")
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .tracking(4)
                .foregroundStyle(Theme.gold)

            ZStack {
                Circle()
                    .fill(accent.opacity(0.2))
                    .frame(width: 220, height: 220)
                    .scaleEffect(hammerStrike ? 1.05 : 1.0)
                    .animation(.easeOut(duration: 0.7).repeatForever(autoreverses: true), value: hammerStrike)

                Circle()
                    .strokeBorder(accent, lineWidth: 2)
                    .frame(width: 180, height: 180)

                Image(systemName: isGuilty ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .font(.system(size: 90, weight: .black))
                    .foregroundStyle(accent)
                    .shadow(color: accent.opacity(0.7), radius: 16)
                    .rotationEffect(.degrees(hammerStrike ? 0 : -8))
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: hammerStrike)
            }

            Text(isGuilty ? "GUILTY" : "NOT GUILTY")
                .font(.system(size: 44, weight: .black, design: .serif))
                .foregroundStyle(accent)
                .tracking(3)
                .opacity(revealText ? 1 : 0)
                .offset(y: revealText ? 0 : 12)
                .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.2), value: revealText)

            if !summary.isEmpty {
                Text(summary)
                    .font(.system(.body, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .opacity(revealText ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.45), value: revealText)
            }

            Spacer()
        }
        .onAppear {
            hammerStrike = true
            withAnimation { revealText = true }
        }
    }
}

// MARK: - Payout

private struct PayoutView: View {
    let crimeCase: CrimeCase
    let isGuilty: Bool
    let reward: Int
    let fine: Int
    @Binding var path: NavigationPath

    private var accent: Color {
        isGuilty ? Theme.leafGreen : Theme.bloodRed
    }

    private var caseTimeMs: Int? {
        CrimeSceneSession.shared.lastVerdict?.caseTimeMilliseconds
    }

    var body: some View {
        VStack(spacing: 22) {
            Spacer(minLength: 24)

            Image(systemName: isGuilty ? "checkmark.seal.fill" : "xmark.seal.fill")
                .font(.system(size: 64, weight: .heavy))
                .foregroundStyle(accent)

            Text(isGuilty ? "GUILTY" : "NOT GUILTY")
                .font(.system(size: 32, weight: .black, design: .serif))
                .foregroundStyle(accent)
                .tracking(2)

            // Suspect reveal line (the storytelling beat)
            Text(isGuilty
                 ? crimeCase.suspectReveal
                 : "The bench is unconvinced. The shadow walks free.")
                .font(.system(.body, design: .serif).italic())
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    if isGuilty {
                        payoutBlock(
                            icon: "fingerprint",
                            label: "Reward",
                            value: "+\(reward)",
                            color: Theme.gold
                        )
                    } else {
                        payoutBlock(
                            icon: "exclamationmark.triangle.fill",
                            label: "Fine",
                            value: "−\(fine)",
                            color: Theme.bloodRed
                        )
                    }
                }

                if isGuilty, let ms = caseTimeMs {
                    Divider().background(Theme.gold.opacity(0.2))
                    payoutBlock(
                        icon: "stopwatch.fill",
                        label: "Case Time",
                        value: CaseTimer.format(milliseconds: ms),
                        color: Theme.gold
                    )
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .glassCard(corner: 16)
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 10) {
                if isGuilty, let ms = caseTimeMs {
                    ChallengeAFriendButton(crimeCase: crimeCase, milliseconds: ms)
                }

                PrimaryButton(
                    title: "Return to the Office",
                    systemImage: "house.fill",
                    style: .gold
                ) {
                    path = NavigationPath()
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 16)
        }
    }

    private func payoutBlock(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.18)).frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label.uppercased())
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(Theme.textMuted)
                Text(value)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(color)
            }
            Spacer()
        }
    }
}

private struct ChallengeAFriendButton: View {
    let crimeCase: CrimeCase
    let milliseconds: Int

    private var appStoreURL: URL { ForceUpdateChecker.appStoreURL }

    private var shareMessage: String {
        let time = CaseTimer.format(milliseconds: milliseconds)
        return "I cracked \"\(crimeCase.title)\" in \(time) on Sleuth Star. Beat my time: \(appStoreURL.absoluteString)"
    }

    var body: some View {
        ShareLink(
            item: appStoreURL,
            subject: Text("Beat my time on \(crimeCase.title)"),
            message: Text(shareMessage)
        ) {
            HStack(spacing: 10) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 14, weight: .bold))
                Text("Challenge a Friend")
                    .font(.system(.subheadline, design: .serif).weight(.semibold))
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundStyle(Theme.gold)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                Capsule().strokeBorder(Theme.gold.opacity(0.55), lineWidth: 1.2)
            )
        }
        .simultaneousGesture(TapGesture().onEnded { Haptics.tap() })
    }
}
