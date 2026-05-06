import Foundation

enum JudgeService {

    static func evaluate(crimeCase: CrimeCase, presented: [Evidence]) -> VerdictResult {
        let incriminating = presented.filter { $0.isIncriminating }.count
        let redHerrings = presented.filter { !$0.isIncriminating }.count
        let required = crimeCase.minIncriminatingToWin

        let isGuilty: Bool
        let summary: String

        if incriminating >= required && redHerrings <= 1 {
            isGuilty = true
            summary = redHerrings == 0
                ? "Tight case. The bench has no doubt."
                : "Convincing — despite a stray exhibit or two."
        } else if incriminating >= required && redHerrings >= 2 {
            isGuilty = false
            summary = "Too much chaff. The bench questions your judgment."
        } else if incriminating > 0 {
            isGuilty = false
            summary = "Not enough to hang a hat on. Reasonable doubt prevails."
        } else {
            isGuilty = false
            summary = "You presented nothing of weight. The case collapses."
        }

        return VerdictResult(
            caseId: crimeCase.id,
            isGuilty: isGuilty,
            reward: isGuilty ? crimeCase.reward : 0,
            fine: isGuilty ? 0 : crimeCase.fineOnLoss,
            presentedIncriminating: incriminating,
            presentedRedHerrings: redHerrings,
            requiredIncriminating: required,
            summary: summary,
            submittedEvidence: presented
        )
    }
}
