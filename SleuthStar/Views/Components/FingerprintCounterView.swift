import SwiftUI

struct FingerprintCounterView: View {
    let amount: Int
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Theme.goldGradient)
                    .frame(width: compact ? 26 : 30, height: compact ? 26 : 30)
                    .shadow(color: Theme.gold.opacity(0.4), radius: 6)
                Image(systemName: "fingerprint")
                    .font(.system(size: compact ? 14 : 16, weight: .heavy))
                    .foregroundStyle(Theme.midnight)
            }

            Text(amount.formattedFingerprints)
                .font(.system(size: compact ? 16 : 18, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
                .contentTransition(.numericText())
                .monospacedDigit()
        }
        .padding(.vertical, compact ? 6 : 8)
        .padding(.horizontal, compact ? 10 : 14)
        .background(
            Capsule().fill(Theme.coal.opacity(0.7))
        )
        .overlay(
            Capsule().strokeBorder(Theme.gold.opacity(0.35), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        NoirBackground()
        FingerprintCounterView(amount: 1240)
    }
}
