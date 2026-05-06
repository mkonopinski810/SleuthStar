import SwiftUI
import UIKit

@main
struct SleuthStarApp: App {
    @StateObject private var game = GameStateManager.shared
    @StateObject private var gameCenter = GameCenterManager.shared
    @State private var showForceUpdate = false
    @State private var forceUpdateMessage = ""

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(game)
                .environmentObject(gameCenter)
                .preferredColorScheme(.dark)
                .task {
                    gameCenter.authenticate()
                    let (needsUpdate, message) = await ForceUpdateChecker.check()
                    if needsUpdate {
                        forceUpdateMessage = message
                        showForceUpdate = true
                    }
                }
                .fullScreenCover(isPresented: $showForceUpdate) {
                    ForceUpdateView(message: forceUpdateMessage)
                }
        }
    }
}

struct ForceUpdateView: View {
    let message: String

    var body: some View {
        ZStack {
            NoirBackground()

            VStack(spacing: 22) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Theme.gold.opacity(0.18))
                        .frame(width: 180, height: 180)
                        .blur(radius: 16)
                    Circle()
                        .strokeBorder(Theme.gold.opacity(0.6), lineWidth: 2)
                        .frame(width: 130, height: 130)
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 64, weight: .heavy))
                        .foregroundStyle(Theme.gold)
                        .shadow(color: Theme.gold.opacity(0.7), radius: 14)
                }

                VStack(spacing: 8) {
                    Text("UPDATE REQUIRED")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(3)
                        .foregroundStyle(Theme.gold)
                    Text("A New Edition")
                        .font(.system(.largeTitle, design: .serif).weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                }

                Text(message)
                    .font(.system(.body, design: .serif).italic())
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                PrimaryButton(
                    title: "Update Now",
                    systemImage: "arrow.down.app.fill",
                    style: .gold
                ) {
                    UIApplication.shared.open(ForceUpdateChecker.appStoreURL)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 18)
            }
        }
    }
}
