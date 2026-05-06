import SwiftUI

struct SplashView: View {
    var onContinue: () -> Void
    @State private var lensOffset: CGFloat = -160
    @State private var titleAppear = false
    @State private var ctaAppear = false
    @State private var glow = false

    var body: some View {
        ZStack {
            NoirBackground()

            VStack(spacing: 20) {
                Spacer()

                // Lens / star mark
                ZStack {
                    Circle()
                        .fill(Theme.gold.opacity(glow ? 0.20 : 0.08))
                        .frame(width: 220, height: 220)
                        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: glow)

                    Circle()
                        .strokeBorder(Theme.gold.opacity(0.6), lineWidth: 2)
                        .frame(width: 160, height: 160)

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 100, weight: .heavy))
                        .foregroundStyle(Theme.gold)
                        .shadow(color: Theme.gold.opacity(0.6), radius: 18)
                        .offset(x: lensOffset)
                        .animation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.1), value: lensOffset)

                    Image(systemName: "star.fill")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(Theme.gold)
                        .shadow(color: Theme.gold.opacity(0.7), radius: 6)
                        .offset(x: 36, y: -34)
                        .opacity(titleAppear ? 1 : 0)
                }

                VStack(spacing: 6) {
                    Text("SLEUTH")
                        .font(.system(size: 56, weight: .black, design: .serif))
                        .foregroundStyle(Theme.textPrimary)
                        .tracking(8)

                    Text("STAR")
                        .font(.system(size: 56, weight: .black, design: .serif))
                        .foregroundStyle(Theme.gold)
                        .tracking(8)
                }
                .opacity(titleAppear ? 1 : 0)
                .offset(y: titleAppear ? 0 : 24)
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: titleAppear)

                Text(AppInfo.tagline)
                    .font(.system(.body, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
                    .opacity(titleAppear ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: titleAppear)

                Spacer()

                PrimaryButton(
                    title: "Open the Office",
                    systemImage: "key.fill",
                    style: .gold
                ) {
                    onContinue()
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
                .opacity(ctaAppear ? 1 : 0)
                .offset(y: ctaAppear ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: ctaAppear)
            }
        }
        .onAppear {
            glow = true
            lensOffset = 0
            titleAppear = true
            ctaAppear = true
        }
    }
}
