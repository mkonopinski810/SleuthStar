import Foundation
import CoreGraphics

struct Evidence: Identifiable, Codable, Hashable {
    let id: String
    let type: EvidenceType
    let name: String
    let description: String
    let isIncriminating: Bool
    let normalizedX: Double
    let normalizedY: Double
    let hint: String?
    let analysis: EvidenceAnalysis?
    let surfaceIcon: String
    let surfaceLabel: String
    let judgeLine: String

    init(
        id: String = UUID().uuidString,
        type: EvidenceType,
        name: String,
        description: String,
        isIncriminating: Bool,
        normalizedX: Double,
        normalizedY: Double,
        hint: String? = nil,
        analysis: EvidenceAnalysis? = nil,
        surfaceIcon: String = "questionmark.app",
        surfaceLabel: String = "AT THE SCENE",
        judgeLine: String = "Noted."
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.isIncriminating = isIncriminating
        self.normalizedX = normalizedX
        self.normalizedY = normalizedY
        self.hint = hint
        self.analysis = analysis
        self.surfaceIcon = surfaceIcon
        self.surfaceLabel = surfaceLabel
        self.judgeLine = judgeLine
    }

    var position: CGPoint {
        CGPoint(x: normalizedX, y: normalizedY)
    }
}
