import SwiftUI

struct NoirBackground: View {
    var tint: Color = Theme.smoke
    @State private var pulse = false

    var body: some View {
        ZStack {
            Theme.noirBackground
                .ignoresSafeArea()

            // Soft golden glow upper right
            RadialGradient(
                colors: [Theme.gold.opacity(0.18), .clear],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 380
            )
            .ignoresSafeArea()

            // Bottom blue glow
            RadialGradient(
                colors: [tint.opacity(0.35), .clear],
                center: .bottomLeading,
                startRadius: 0,
                endRadius: 480
            )
            .ignoresSafeArea()

            // Subtle pulsing vignette
            RadialGradient(
                colors: [.clear, Theme.midnight.opacity(0.85)],
                center: .center,
                startRadius: 240,
                endRadius: 700
            )
            .ignoresSafeArea()
            .opacity(pulse ? 1.0 : 0.85)
            .animation(
                .easeInOut(duration: 6).repeatForever(autoreverses: true),
                value: pulse
            )

            // Grain texture (very subtle)
            GrainOverlay()
                .opacity(0.06)
                .blendMode(.overlay)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .onAppear { pulse = true }
    }
}

private struct GrainOverlay: View {
    var body: some View {
        Canvas { context, size in
            let count = Int(size.width * size.height / 1200)
            for _ in 0..<count {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let s = CGFloat.random(in: 0.4...1.4)
                let alpha = Double.random(in: 0.05...0.18)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: s, height: s)),
                    with: .color(.white.opacity(alpha))
                )
            }
        }
    }
}

#Preview {
    NoirBackground()
}
