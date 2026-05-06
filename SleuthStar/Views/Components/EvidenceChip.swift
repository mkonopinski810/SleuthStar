import SwiftUI

struct EvidenceChip: View {
    let evidence: Evidence
    var selected: Bool = false
    var compact: Bool = false
    var showsPolaroid: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .fill(evidence.type.tintColor.opacity(0.22))
                        .frame(width: compact ? 28 : 34, height: compact ? 28 : 34)
                    Image(systemName: evidence.type.iconName)
                        .font(.system(size: compact ? 14 : 16, weight: .bold))
                        .foregroundStyle(evidence.type.tintColor)
                }
                if showsPolaroid {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(Theme.midnight)
                        .padding(3)
                        .background(Circle().fill(Theme.gold))
                        .offset(x: 4, y: -4)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(evidence.name)
                    .font(.system(size: compact ? 13 : 14, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                Text(evidence.type.displayName)
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1)
                    .foregroundStyle(Theme.textMuted)
            }

            Spacer(minLength: 0)

            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Theme.gold)
                    .font(.system(size: 18, weight: .bold))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .glassCard(corner: 14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(selected ? Theme.gold : Color.clear, lineWidth: 1.5)
        )
    }
}

#Preview {
    ZStack {
        NoirBackground()
        VStack {
            EvidenceChip(
                evidence: Evidence(
                    type: .fingerprint,
                    name: "Smudged Fingerprint",
                    description: "...",
                    isIncriminating: true,
                    normalizedX: 0,
                    normalizedY: 0
                ),
                selected: true
            )
            EvidenceChip(
                evidence: Evidence(
                    type: .note,
                    name: "Crumpled Note",
                    description: "...",
                    isIncriminating: true,
                    normalizedX: 0,
                    normalizedY: 0
                )
            )
        }
        .padding()
    }
}
