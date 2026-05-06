import Foundation

struct PlayerProfile: Codable {
    var fingerprints: Int
    var ownedItemIds: Set<String>
    var solvedCaseIds: Set<String>
    var failedCaseIds: Set<String>
    var hasSeenIntro: Bool
    var lifetimeFingerprints: Int

    static let starter = PlayerProfile(
        fingerprints: 250,
        ownedItemIds: ["eq-magnifier"],
        solvedCaseIds: [],
        failedCaseIds: [],
        hasSeenIntro: false,
        lifetimeFingerprints: 0
    )

    private enum CodingKeys: String, CodingKey {
        case fingerprints, ownedItemIds, solvedCaseIds, failedCaseIds, hasSeenIntro, lifetimeFingerprints
    }

    init(
        fingerprints: Int,
        ownedItemIds: Set<String>,
        solvedCaseIds: Set<String>,
        failedCaseIds: Set<String>,
        hasSeenIntro: Bool,
        lifetimeFingerprints: Int
    ) {
        self.fingerprints = fingerprints
        self.ownedItemIds = ownedItemIds
        self.solvedCaseIds = solvedCaseIds
        self.failedCaseIds = failedCaseIds
        self.hasSeenIntro = hasSeenIntro
        self.lifetimeFingerprints = lifetimeFingerprints
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.fingerprints = try c.decode(Int.self, forKey: .fingerprints)
        self.ownedItemIds = try c.decode(Set<String>.self, forKey: .ownedItemIds)
        self.solvedCaseIds = try c.decode(Set<String>.self, forKey: .solvedCaseIds)
        self.failedCaseIds = try c.decode(Set<String>.self, forKey: .failedCaseIds)
        self.hasSeenIntro = try c.decode(Bool.self, forKey: .hasSeenIntro)
        self.lifetimeFingerprints = try c.decodeIfPresent(Int.self, forKey: .lifetimeFingerprints) ?? 0
    }
}
