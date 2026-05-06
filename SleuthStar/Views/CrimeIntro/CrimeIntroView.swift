import SwiftUI

struct CrimeIntroView: View {
    let crimeCase: CrimeCase
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var game: GameStateManager

    @State private var phase: IntroPhase = .opening
    @State private var fadeOut: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Per-case choreography
            switch crimeCase.id {
            case "case-001-rooftop":
                RooftopRobberyScene(phase: phase)
            case "case-002-midnight":
                MidnightHeistScene(phase: phase)
            case "case-003-diamond":
                DiamondVanishScene(phase: phase)
            case "case-004-masquerade":
                MasqueradeScene(phase: phase)
            default:
                GenericCrimeScene(phase: phase, crimeCase: crimeCase)
            }

            // Title slam (shared)
            IntroTitleSlam(
                title: crimeCase.title.uppercased(),
                kicker: crimeCase.location.uppercased(),
                visible: phase == .title
            )

            // Letterboxing
            VStack {
                Rectangle().fill(.black).frame(height: 56)
                Spacer()
                Rectangle().fill(.black).frame(height: 80)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // Skip button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        Haptics.tap()
                        finishIntro()
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
                .padding(.horizontal, 20)
                .padding(.top, 18)
                Spacer()
            }

            // Fade-out cover
            Color.black
                .opacity(fadeOut ? 1 : 0)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .statusBarHidden(true)
        .onAppear {
            // Driver assistant: skip the cutscene entirely.
            if game.skipIntroCutscene {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    finishIntro()
                }
                return
            }
            runChoreography()
        }
    }

    // MARK: - Timing

    private func runChoreography() {
        let beats: [(IntroPhase, Double)] = [
            (.opening, 0.0),
            (.skyline, 0.6),
            (.zoom, 1.7),
            (.figure, 2.7),
            (.flash, 3.6),
            (.entry, 4.1),
            (.evidence, 5.0),
            (.title, 6.0),
            (.outro, 8.0)
        ]

        for (p, delay) in beats {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if phase == .skipped { return }
                withAnimation(.easeInOut(duration: 0.6)) {
                    phase = p
                }
                if p == .flash {
                    Haptics.warning()
                } else if p == .title {
                    Haptics.success()
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 8.6) {
            if phase == .skipped { return }
            finishIntro()
        }
    }

    private func finishIntro() {
        guard phase != .skipped else { return }
        phase = .skipped
        withAnimation(.easeOut(duration: 0.5)) {
            fadeOut = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            path.removeLast()
            path.append(AppRoute.briefing(caseId: crimeCase.id))
        }
    }
}

// MARK: - Phases

enum IntroPhase {
    case opening   // black
    case skyline   // city skyline fades in
    case zoom      // spotlight on the target
    case figure    // shadowy figure approaches
    case flash     // lightning flash
    case entry     // figure enters / crime happens
    case evidence  // evidence montage
    case title     // big title slam
    case outro     // fade out
    case skipped
}

// MARK: - Title slam

private struct IntroTitleSlam: View {
    let title: String
    let kicker: String
    let visible: Bool

    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Text(kicker)
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .tracking(4)
                .foregroundStyle(Theme.gold)
                .opacity(visible ? 1 : 0)
                .offset(y: visible ? 0 : -8)
                .animation(.easeOut(duration: 0.5).delay(0.15), value: visible)

            Text(title)
                .font(.system(size: 38, weight: .black, design: .serif))
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 6)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .scaleEffect(visible ? 1.0 : 1.4)
                .opacity(visible ? 1 : 0)
                .blur(radius: visible ? 0 : 6)
                .animation(.spring(response: 0.55, dampingFraction: 0.55), value: visible)

            // Underline
            Rectangle()
                .fill(Theme.gold)
                .frame(width: visible ? 140 : 0, height: 2)
                .animation(.easeOut(duration: 0.7).delay(0.25), value: visible)
            Spacer()
        }
    }
}

// MARK: - The Rooftop Robbery scene

private struct RooftopRobberyScene: View {
    let phase: IntroPhase

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Night sky gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.04, green: 0.05, blue: 0.13),
                        Color(red: 0.10, green: 0.08, blue: 0.22),
                        Color(red: 0.16, green: 0.12, blue: 0.18)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(skyOpacity)

                // Moon
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.white.opacity(0.9), Color(red: 0.95, green: 0.92, blue: 0.85).opacity(0.4)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 80, height: 80)
                    .position(x: geo.size.width * 0.78, y: geo.size.height * 0.20)
                    .blur(radius: 1)
                    .opacity(skyOpacity)

                // Rain streaks
                if phase != .opening {
                    RainOverlay()
                        .opacity(0.45)
                        .blendMode(.screen)
                }

                // City skyline silhouette
                CitySkyline(geo: geo)
                    .opacity(skyOpacity)

                // Penthouse highlight ring
                Circle()
                    .strokeBorder(Theme.gold.opacity(spotlightOpacity), lineWidth: 2)
                    .frame(width: spotlightSize, height: spotlightSize)
                    .position(x: geo.size.width * 0.50, y: geo.size.height * 0.42)
                    .blur(radius: 1)
                    .shadow(color: Theme.gold.opacity(0.6), radius: 14)

                // Lit window in penthouse
                RoundedRectangle(cornerRadius: 2)
                    .fill(windowGlowColor)
                    .frame(width: 26, height: 36)
                    .position(x: geo.size.width * 0.50, y: geo.size.height * 0.42)
                    .shadow(color: Theme.gold.opacity(windowAfterglow), radius: 10)

                // Shadowy figure climbing
                FigureSilhouette(rope: true)
                    .frame(width: 60, height: 90)
                    .position(
                        x: geo.size.width * 0.50,
                        y: figureY(geo: geo)
                    )
                    .opacity(figureOpacity)

                // Lightning flash overlay
                Color.white
                    .opacity(flashOpacity)
                    .ignoresSafeArea()
                    .blendMode(.screen)

                // Evidence montage cards (mid-air)
                if phase == .evidence {
                    EvidenceMontage(geo: geo)
                }

                // Vignette
                RadialGradient(
                    colors: [.clear, .black.opacity(0.85)],
                    center: .center,
                    startRadius: 120,
                    endRadius: 460
                )
                .ignoresSafeArea()
                .blendMode(.multiply)
            }
        }
    }

    // MARK: - Phase-driven values

    private var skyOpacity: Double {
        switch phase {
        case .opening: return 0
        case .outro: return 0.3
        default: return 1
        }
    }

    private var spotlightOpacity: Double {
        switch phase {
        case .opening, .skyline: return 0
        case .zoom, .figure, .flash, .entry: return 0.85
        case .evidence: return 0.4
        case .title, .outro, .skipped: return 0
        }
    }

    private var spotlightSize: CGFloat {
        switch phase {
        case .opening, .skyline: return 280
        case .zoom: return 150
        default: return 120
        }
    }

    private var windowGlowColor: Color {
        switch phase {
        case .opening, .skyline: return Color(red: 0.20, green: 0.18, blue: 0.10)
        case .zoom, .figure: return Color(red: 0.95, green: 0.78, blue: 0.36)
        case .flash: return .white
        case .entry, .evidence: return Color(red: 0.20, green: 0.10, blue: 0.10)
        default: return Color(red: 0.10, green: 0.08, blue: 0.06)
        }
    }

    private var windowAfterglow: Double {
        switch phase {
        case .zoom, .figure: return 0.7
        case .flash: return 1.0
        default: return 0.2
        }
    }

    private var flashOpacity: Double {
        phase == .flash ? 0.7 : 0
    }

    private func figureY(geo: GeometryProxy) -> CGFloat {
        switch phase {
        case .opening, .skyline, .zoom: return geo.size.height * 0.95
        case .figure: return geo.size.height * 0.55
        case .flash: return geo.size.height * 0.50
        case .entry, .evidence, .title, .outro, .skipped: return geo.size.height * 0.42
        }
    }

    private var figureOpacity: Double {
        switch phase {
        case .opening, .skyline, .zoom: return 0
        case .figure, .flash: return 1
        case .entry: return 0.6
        case .evidence, .title, .outro, .skipped: return 0
        }
    }
}

// MARK: - City skyline

private struct CitySkyline: View {
    let geo: GeometryProxy

    var body: some View {
        ZStack(alignment: .bottom) {
            // Far buildings
            BuildingsRow(
                heights: [60, 90, 70, 110, 80, 95, 70, 100, 75, 85, 95, 70],
                color: Color(red: 0.06, green: 0.07, blue: 0.14),
                windows: false,
                geo: geo
            )

            // Mid buildings (with windows)
            BuildingsRow(
                heights: [110, 150, 180, 130, 170, 220, 140, 200, 160, 130],
                color: Color(red: 0.04, green: 0.05, blue: 0.10),
                windows: true,
                geo: geo
            )
            .offset(y: 20)
        }
    }
}

private struct BuildingsRow: View {
    let heights: [CGFloat]
    let color: Color
    let windows: Bool
    let geo: GeometryProxy

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(Array(heights.enumerated()), id: \.offset) { idx, h in
                Building(height: h, color: color, windows: windows, seed: idx)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct Building: View {
    let height: CGFloat
    let color: Color
    let windows: Bool
    let seed: Int

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle().fill(color)

            if windows {
                VStack(spacing: 6) {
                    ForEach(0..<Int(height/14), id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<3, id: \.self) { col in
                                Rectangle()
                                    .fill(windowColor(row: row, col: col))
                                    .frame(width: 4, height: 5)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(0.85)
            }
        }
        .frame(height: height)
    }

    private func windowColor(row: Int, col: Int) -> Color {
        // Pseudo-random lit/dark based on seed
        let hash = (seed &* 31 &+ row &* 7 &+ col) % 7
        switch hash {
        case 0, 1: return Color(red: 0.95, green: 0.78, blue: 0.32).opacity(0.85)
        case 2: return Color(red: 0.50, green: 0.65, blue: 0.85).opacity(0.7)
        default: return Color.black.opacity(0.6)
        }
    }
}

// MARK: - Figure silhouette

private struct FigureSilhouette: View {
    var rope: Bool = false

    var body: some View {
        ZStack {
            // Rope
            if rope {
                Rectangle()
                    .fill(Color(red: 0.30, green: 0.20, blue: 0.12))
                    .frame(width: 1.5)
                    .frame(maxHeight: .infinity)
            }

            // Body silhouette (composited from shapes)
            VStack(spacing: -8) {
                // Hat
                Capsule()
                    .fill(Color.black)
                    .frame(width: 32, height: 16)
                Capsule()
                    .fill(Color.black)
                    .frame(width: 50, height: 6)

                // Head + coat
                VStack(spacing: -2) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 22, height: 22)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .frame(width: 38, height: 50)
                }
            }
            .shadow(color: .black.opacity(0.9), radius: 4)
        }
    }
}

// MARK: - Evidence montage

private struct EvidenceMontage: View {
    let geo: GeometryProxy
    @State private var stage = 0

    private let pieces: [(EvidenceType, Double, Double)] = [
        (.fingerprint, 0.30, 0.42),
        (.note, 0.60, 0.55),
        (.footprint, 0.45, 0.66)
    ]

    var body: some View {
        ZStack {
            ForEach(Array(pieces.enumerated()), id: \.offset) { idx, item in
                let (type, x, y) = item
                EvidenceFlash(type: type, delay: Double(idx) * 0.25)
                    .position(x: geo.size.width * x, y: geo.size.height * y)
            }
        }
    }
}

private struct EvidenceFlash: View {
    let type: EvidenceType
    let delay: Double
    @State private var visible = false
    @State private var rotate: Double = -10

    var body: some View {
        ZStack {
            Circle()
                .fill(type.tintColor.opacity(0.30))
                .frame(width: 90, height: 90)
                .blur(radius: 8)

            Circle()
                .fill(type.tintColor.opacity(0.18))
                .frame(width: 70, height: 70)

            Circle()
                .strokeBorder(type.tintColor, lineWidth: 1.5)
                .frame(width: 56, height: 56)

            Image(systemName: type.iconName)
                .font(.system(size: 28, weight: .black))
                .foregroundStyle(type.tintColor)
                .shadow(color: type.tintColor.opacity(0.7), radius: 8)
        }
        .scaleEffect(visible ? 1.0 : 0.4)
        .opacity(visible ? 1 : 0)
        .rotationEffect(.degrees(rotate))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.55)) {
                    visible = true
                    rotate = 0
                }
            }
        }
    }
}

// MARK: - Rain overlay

private struct RainOverlay: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            let count = 80
            for i in 0..<count {
                let x = (CGFloat(i) * 13.7).truncatingRemainder(dividingBy: size.width)
                let yBase = (CGFloat(i) * 27.3).truncatingRemainder(dividingBy: size.height)
                let y = (yBase + phase).truncatingRemainder(dividingBy: size.height)
                let path = Path { p in
                    p.move(to: CGPoint(x: x, y: y))
                    p.addLine(to: CGPoint(x: x - 2, y: y + 14))
                }
                context.stroke(path, with: .color(.white.opacity(0.22)), lineWidth: 0.7)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 0.6).repeatForever(autoreverses: false)) {
                phase = 600
            }
        }
    }
}

// MARK: - Generic + locked-case fallbacks

private struct GenericCrimeScene: View {
    let phase: IntroPhase
    let crimeCase: CrimeCase

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: crimeCase.sceneTint[0], green: crimeCase.sceneTint[1], blue: crimeCase.sceneTint[2]),
                        Color(red: crimeCase.sceneTint[0] * 0.3, green: crimeCase.sceneTint[1] * 0.3, blue: crimeCase.sceneTint[2] * 0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(opacity)

                Image(systemName: crimeCase.sceneIcon)
                    .font(.system(size: 200, weight: .bold))
                    .foregroundStyle(.white.opacity(0.18))
                    .scaleEffect(scaleVal)

                if phase == .figure || phase == .flash || phase == .entry {
                    FigureSilhouette()
                        .frame(width: 80, height: 110)
                        .position(x: geo.size.width * 0.5, y: geo.size.height * 0.55)
                        .opacity(phase == .entry ? 0.5 : 1)
                }

                Color.white.opacity(phase == .flash ? 0.6 : 0).ignoresSafeArea()

                RadialGradient(colors: [.clear, .black.opacity(0.85)], center: .center, startRadius: 120, endRadius: 460)
                    .ignoresSafeArea()
            }
        }
    }

    private var opacity: Double {
        phase == .opening ? 0 : 1
    }

    private var scaleVal: CGFloat {
        switch phase {
        case .opening, .skyline: return 0.6
        case .zoom: return 1.0
        case .figure, .flash: return 1.1
        case .entry, .evidence: return 1.2
        default: return 1.3
        }
    }
}

private struct MidnightHeistScene: View {
    let phase: IntroPhase
    var body: some View { GenericCrimeScene(phase: phase, crimeCase: CaseRepository.midnightHeist) }
}

private struct DiamondVanishScene: View {
    let phase: IntroPhase
    var body: some View { GenericCrimeScene(phase: phase, crimeCase: CaseRepository.diamondVanish) }
}

private struct MasqueradeScene: View {
    let phase: IntroPhase
    var body: some View { GenericCrimeScene(phase: phase, crimeCase: CaseRepository.masquerade) }
}
