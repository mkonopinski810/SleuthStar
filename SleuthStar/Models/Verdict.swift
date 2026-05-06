import Foundation

struct VerdictResult: Hashable {
    let caseId: String
    let isGuilty: Bool
    let reward: Int
    let fine: Int
    let presentedIncriminating: Int
    let presentedRedHerrings: Int
    let requiredIncriminating: Int
    let summary: String
    let submittedEvidence: [Evidence]
    var caseTimeMilliseconds: Int? = nil
}
