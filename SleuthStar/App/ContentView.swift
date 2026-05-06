import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: GameStateManager
    @State private var path = NavigationPath()
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                        game.profile.hasSeenIntro = true
                    }
                }
                .transition(.opacity)
            } else {
                NavigationStack(path: $path) {
                    OfficeView(path: $path)
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .transition(.opacity)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .office:
            OfficeView(path: $path)

        case .intro(let caseId):
            if let crimeCase = CaseRepository.byId(caseId) {
                CrimeIntroView(crimeCase: crimeCase, path: $path)
            } else {
                missingCaseView(caseId: caseId)
            }

        case .briefing(let caseId):
            if let crimeCase = CaseRepository.byId(caseId) {
                BriefingView(crimeCase: crimeCase, path: $path)
            } else {
                missingCaseView(caseId: caseId)
            }

        case .crimeScene(let caseId):
            if let crimeCase = CaseRepository.byId(caseId) {
                CrimeSceneViewWrapper(crimeCase: crimeCase, path: $path)
            } else {
                missingCaseView(caseId: caseId)
            }

        case .courtroom(let caseId):
            if let crimeCase = CaseRepository.byId(caseId) {
                CourtroomViewWrapper(crimeCase: crimeCase, path: $path)
            } else {
                missingCaseView(caseId: caseId)
            }

        case .verdict(let caseId, let isGuilty, let reward, let fine):
            if let crimeCase = CaseRepository.byId(caseId) {
                VerdictView(
                    crimeCase: crimeCase,
                    isGuilty: isGuilty,
                    reward: reward,
                    fine: fine,
                    path: $path
                )
            } else {
                missingCaseView(caseId: caseId)
            }

        case .shop:
            ShopView()

        case .career:
            CareerView()

        case .leaderboard:
            LeaderboardView()
        }
    }

    private func missingCaseView(caseId: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.folder")
                .font(.system(size: 40))
                .foregroundStyle(Theme.textMuted)
            Text("Case file not found: \(caseId)")
                .font(.system(.subheadline, design: .serif).italic())
                .foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NoirBackground())
    }
}

// MARK: - Wrappers (the scene + courtroom both need shared collected-evidence state)

private struct CrimeSceneViewWrapper: View {
    let crimeCase: CrimeCase
    @Binding var path: NavigationPath

    var body: some View {
        CrimeSceneView(crimeCase: crimeCase, path: $path)
    }
}

private struct CourtroomViewWrapper: View {
    let crimeCase: CrimeCase
    @Binding var path: NavigationPath

    var body: some View {
        // Courtroom uses CrimeSceneSession via shared environment.
        // For vertical slice we read from CrimeSceneSession singleton.
        CourtroomView(
            crimeCase: crimeCase,
            collectedEvidence: CrimeSceneSession.shared.collected(for: crimeCase),
            path: $path
        )
    }
}
