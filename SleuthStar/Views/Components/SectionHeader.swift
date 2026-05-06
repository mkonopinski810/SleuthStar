import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Theme.gold)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle().fill(Theme.gold.opacity(0.12))
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .tracking(2.0)
                    .foregroundStyle(Theme.gold)

                if let subtitle {
                    Text(subtitle)
                        .font(.system(.title3, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        NoirBackground()
        SectionHeader(title: "Active Case", subtitle: "The Rooftop Robbery", icon: "magnifyingglass")
            .padding()
    }
}
