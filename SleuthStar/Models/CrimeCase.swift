import Foundation

struct CrimeCase: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let blurb: String
    let location: String
    let difficulty: CaseDifficulty
    let suspect: Suspect
    let sceneIcon: String
    let sceneTint: [Double]
    let evidence: [Evidence]
    let minIncriminatingToWin: Int
    let reward: Int
    let fineOnLoss: Int
    let unlockCost: Int
    let requiresCaseId: String?
    let truth: [String]
    let suspectReveal: String

    init(
        id: String,
        title: String,
        blurb: String,
        location: String,
        difficulty: CaseDifficulty,
        suspect: Suspect,
        sceneIcon: String,
        sceneTint: [Double],
        evidence: [Evidence],
        minIncriminatingToWin: Int,
        reward: Int,
        fineOnLoss: Int,
        unlockCost: Int,
        requiresCaseId: String? = nil,
        truth: [String] = [],
        suspectReveal: String = "The Shadow has a name now."
    ) {
        self.id = id
        self.title = title
        self.blurb = blurb
        self.location = location
        self.difficulty = difficulty
        self.suspect = suspect
        self.sceneIcon = sceneIcon
        self.sceneTint = sceneTint
        self.evidence = evidence
        self.minIncriminatingToWin = minIncriminatingToWin
        self.reward = reward
        self.fineOnLoss = fineOnLoss
        self.unlockCost = unlockCost
        self.requiresCaseId = requiresCaseId
        self.truth = truth
        self.suspectReveal = suspectReveal
    }

    var requiredCount: Int {
        evidence.filter { $0.isIncriminating }.count
    }
}
