import SwiftUI

struct EvidenceRoomView: View {
    let evidence: Evidence
    let alreadyCollected: Bool
    let onCollect: () -> Void
    let onDismiss: () -> Void

    @State private var entered: Bool = false
    @State private var showInspect: Bool = false
    @State private var dustOffset: CGFloat = 0

    private var tint: Color { evidence.type.tintColor }

    var body: some View {
        ZStack {
            // Dark base
            Color.black.ignoresSafeArea()

            // Walls + floor "room" composition
            RoomComposition(evidence: evidence, entered: entered)

            // Drifting dust motes (atmosphere)
            DustOverlay(offset: dustOffset)
                .blendMode(.screen)
                .opacity(0.7)
                .allowsHitTesting(false)

            // Vignette
            RadialGradient(
                colors: [.clear, .black.opacity(0.85)],
                center: .center,
                startRadius: 140,
                endRadius: 520
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // Overlay UI
            VStack(spacing: 0) {
                topBar
                Spacer()
                bottomBar
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                entered = true
            }
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                dustOffset = 1
            }
        }
        .sheet(isPresented: $showInspect) {
            EvidenceInspectSheet(
                evidence: evidence,
                mode: alreadyCollected ? .review : .discovery,
                onCollect: {
                    showInspect = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onCollect()
                    }
                },
                onDismiss: {
                    showInspect = false
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationBackground(Theme.ink)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                Haptics.tap()
                onDismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 13, weight: .heavy))
                    Text("BACK")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(1.6)
                }
                .foregroundStyle(Theme.textPrimary)
                .padding(.horizontal, 14).padding(.vertical, 9)
                .glassCard(corner: 12)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("YOU SEARCH")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(1.8)
                    .foregroundStyle(Theme.gold.opacity(0.9))
                Text(evidence.surfaceLabel)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textPrimary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var bottomBar: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                Text(evidence.type.displayName.uppercased())
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(tint)
                Text(evidence.name)
                    .font(.system(.title3, design: .serif).weight(.semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 22)

            PrimaryButton(
                title: alreadyCollected ? "Examine Again" : "Examine",
                systemImage: "magnifyingglass",
                style: .gold
            ) {
                showInspect = true
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 22)
    }
}

// MARK: - Room composition

private struct RoomComposition: View {
    let evidence: Evidence
    let entered: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Wall (top 70%) and floor (bottom 30%) with perspective
                VStack(spacing: 0) {
                    // Back wall
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.10, blue: 0.16),
                            Color(red: 0.16, green: 0.12, blue: 0.20),
                            Color(red: 0.20, green: 0.14, blue: 0.18)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.66)

                    // Floor
                    LinearGradient(
                        colors: [
                            Color(red: 0.18, green: 0.14, blue: 0.12),
                            Color(red: 0.06, green: 0.04, blue: 0.04)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.34)
                }

                // Wall/floor seam — soft shadow line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 12)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.66)

                // Off-screen window glow casting onto the wall
                RadialGradient(
                    colors: [Theme.gold.opacity(0.20), .clear],
                    center: UnitPoint(x: -0.05, y: 0.20),
                    startRadius: 0,
                    endRadius: max(geo.size.width, geo.size.height) * 0.95
                )

                // Surface item — the "thing" in the room (safe, till, windowsill, etc.)
                SurfaceFurniture(
                    iconName: evidence.surfaceIcon,
                    geo: geo,
                    entered: entered
                )

                // Evidence prop sitting on the surface — pulses gold
                EvidenceFocus(
                    evidence: evidence,
                    geo: geo,
                    entered: entered
                )
            }
        }
    }
}

private struct SurfaceFurniture: View {
    let iconName: String
    let geo: GeometryProxy
    let entered: Bool

    var body: some View {
        ZStack {
            // Subtle gold rim light behind the surface
            Circle()
                .fill(Theme.gold.opacity(0.08))
                .frame(width: 280, height: 280)
                .blur(radius: 30)

            // The surface itself
            Image(systemName: iconName)
                .font(.system(size: 200, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.85),
                            Color(red: 0.35, green: 0.28, blue: 0.22)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.7), radius: 20, x: 8, y: 14)
                .scaleEffect(entered ? 1.0 : 0.6)
                .opacity(entered ? 1.0 : 0.2)
        }
        .position(x: geo.size.width / 2, y: geo.size.height * 0.50)
    }
}

private struct EvidenceFocus: View {
    let evidence: Evidence
    let geo: GeometryProxy
    let entered: Bool

    @State private var pulse = false

    var body: some View {
        ZStack {
            // Pulsing ring
            Circle()
                .strokeBorder(Theme.gold.opacity(pulse ? 0.65 : 0.3), lineWidth: 2)
                .frame(width: pulse ? 130 : 100, height: pulse ? 130 : 100)
                .blur(radius: pulse ? 1 : 0)

            Circle()
                .fill(evidence.type.tintColor.opacity(0.20))
                .frame(width: 90, height: 90)

            Circle()
                .strokeBorder(evidence.type.tintColor, lineWidth: 1.8)
                .frame(width: 72, height: 72)

            Image(systemName: evidence.type.iconName)
                .font(.system(size: 34, weight: .heavy))
                .foregroundStyle(evidence.type.tintColor)
                .shadow(color: evidence.type.tintColor.opacity(0.8), radius: 12)
        }
        .position(
            x: geo.size.width / 2,
            y: geo.size.height * (entered ? 0.66 : 0.50)
        )
        .opacity(entered ? 1 : 0)
        .scaleEffect(entered ? 1.0 : 0.4)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

// MARK: - Dust motes

private struct DustOverlay: View {
    let offset: CGFloat

    var body: some View {
        Canvas { context, size in
            let count = 50
            for i in 0..<count {
                let x = (CGFloat(i) * 17.7).truncatingRemainder(dividingBy: size.width)
                let yBase = (CGFloat(i) * 31.3).truncatingRemainder(dividingBy: size.height)
                let drift = sin((CGFloat(i) + offset * 4) * 0.7) * 6
                let y = (yBase + offset * size.height * 0.5).truncatingRemainder(dividingBy: size.height)
                let r = CGFloat.random(in: 0.5...1.6)
                context.fill(
                    Path(ellipseIn: CGRect(x: x + drift, y: y, width: r, height: r)),
                    with: .color(.white.opacity(0.6))
                )
            }
        }
    }
}
