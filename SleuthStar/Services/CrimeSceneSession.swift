import Foundation

@MainActor
final class CrimeSceneSession: ObservableObject {
    static let shared = CrimeSceneSession()

    @Published private var collectedByCase: [String: [Evidence]] = [:]
    @Published private var revealedTools: [String: Set<AnalysisTool>] = [:]
    @Published var lastVerdict: VerdictResult?

    private init() {}

    func record(caseId: String, evidence: [Evidence]) {
        collectedByCase[caseId] = evidence
    }

    func collected(for crimeCase: CrimeCase) -> [Evidence] {
        collectedByCase[crimeCase.id] ?? []
    }

    func clear(caseId: String) {
        if let evidence = collectedByCase[caseId] {
            for ev in evidence { revealedTools.removeValue(forKey: ev.id) }
        }
        collectedByCase.removeValue(forKey: caseId)
    }

    // MARK: - Analysis revealing

    func revealedTools(for evidenceId: String) -> Set<AnalysisTool> {
        revealedTools[evidenceId] ?? []
    }

    func hasRevealed(_ tool: AnalysisTool, for evidenceId: String) -> Bool {
        revealedTools[evidenceId]?.contains(tool) ?? false
    }

    func markRevealed(_ tool: AnalysisTool, for evidenceId: String) {
        var set = revealedTools[evidenceId] ?? []
        set.insert(tool)
        revealedTools[evidenceId] = set
    }
}
