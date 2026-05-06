import SwiftUI

struct ShopView: View {
    @EnvironmentObject var game: GameStateManager
    @Environment(\.dismiss) private var dismiss
    @State private var category: ShopCategory = .equipment
    @State private var purchaseFlash: String?
    @State private var failFlash: String?
    @State private var scanLine: CGFloat = 0

    var body: some View {
        ZStack {
            NoirBackground()

            VStack(spacing: 14) {
                // Top bar
                HStack {
                    Button {
                        Haptics.tap()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)
                            .frame(width: 36, height: 36)
                            .glassCard(corner: 12)
                    }
                    Spacer()
                    Text("DETECTIVE.NET")
                        .font(.system(size: 11, weight: .heavy, design: .monospaced))
                        .tracking(3)
                        .foregroundStyle(Theme.leafGreen)
                    Spacer()
                    FingerprintCounterView(amount: game.profile.fingerprints, compact: true)
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                // CRT-style monitor frame around content
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(red: 0.04, green: 0.06, blue: 0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(Theme.leafGreen.opacity(0.4), lineWidth: 1.5)
                        )
                        .shadow(color: Theme.leafGreen.opacity(0.3), radius: 18)

                    VStack(spacing: 12) {
                        // Window header
                        HStack(spacing: 6) {
                            Circle().fill(Theme.bloodRed).frame(width: 8, height: 8)
                            Circle().fill(Theme.gold).frame(width: 8, height: 8)
                            Circle().fill(Theme.leafGreen).frame(width: 8, height: 8)
                            Spacer()
                            Text("/var/shop $")
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .foregroundStyle(Theme.leafGreen.opacity(0.8))
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 12)

                        // Category tabs
                        HStack(spacing: 6) {
                            ForEach(ShopCategory.allCases) { cat in
                                CategoryTab(
                                    category: cat,
                                    selected: cat == category
                                ) {
                                    Haptics.tap()
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        category = cat
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)

                        // Item list
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(ShopRepository.items(in: category)) { item in
                                    ShopItemCard(
                                        item: item,
                                        owned: game.owns(item.id),
                                        canAfford: game.profile.fingerprints >= item.price,
                                        flashSuccess: purchaseFlash == item.id,
                                        flashFail: failFlash == item.id
                                    ) {
                                        attemptPurchase(item)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 12)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    // Scanline overlay
                    GeometryReader { geo in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        Theme.leafGreen.opacity(0.18),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 80)
                            .offset(y: scanLine * (geo.size.height + 80) - 80)
                            .blendMode(.screen)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .allowsHitTesting(false)
                }
                .padding(.horizontal, 14)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                scanLine = 1.0
            }
        }
    }

    private func attemptPurchase(_ item: ShopItem) {
        if game.purchase(item) {
            Haptics.success()
            purchaseFlash = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if purchaseFlash == item.id { purchaseFlash = nil }
            }
        } else {
            Haptics.warning()
            failFlash = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if failFlash == item.id { failFlash = nil }
            }
        }
    }
}

private struct CategoryTab: View {
    let category: ShopCategory
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: category.iconName)
                    .font(.system(size: 11, weight: .bold))
                Text(category.displayName)
                    .font(.system(size: 11, weight: .heavy, design: .monospaced))
                    .tracking(0.5)
            }
            .foregroundStyle(selected ? Theme.midnight : Theme.leafGreen)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selected ? Theme.leafGreen : Theme.leafGreen.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Theme.leafGreen.opacity(selected ? 0 : 0.4), lineWidth: 1)
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

private struct ShopItemCard: View {
    let item: ShopItem
    let owned: Bool
    let canAfford: Bool
    let flashSuccess: Bool
    let flashFail: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.leafGreen.opacity(0.12))
                    Image(systemName: item.iconName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Theme.leafGreen)
                }
                .frame(width: 56, height: 56)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).strokeBorder(Theme.leafGreen.opacity(0.4), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(Theme.leafGreen)
                    Text(item.description)
                        .font(.system(size: 11, design: .serif).italic())
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                    HStack(spacing: 4) {
                        Image(systemName: "sparkle")
                            .font(.system(size: 9, weight: .bold))
                        Text(item.perk)
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    }
                    .foregroundStyle(Theme.gold)
                    .padding(.top, 2)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    if owned {
                        Text("OWNED")
                            .font(.system(size: 10, weight: .heavy, design: .monospaced))
                            .tracking(1.4)
                            .foregroundStyle(Theme.gold)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Theme.gold.opacity(0.18))
                            .clipShape(Capsule())
                    } else {
                        HStack(spacing: 3) {
                            Image(systemName: "fingerprint")
                                .font(.system(size: 10, weight: .heavy))
                            Text("\(item.price)")
                                .font(.system(size: 13, weight: .heavy, design: .monospaced))
                        }
                        .foregroundStyle(canAfford ? Theme.gold : Theme.bloodRed)
                        Text(canAfford ? "BUY" : "SHORT")
                            .font(.system(size: 9, weight: .heavy, design: .monospaced))
                            .tracking(1.4)
                            .foregroundStyle(canAfford ? Theme.midnight : Theme.bloodRed)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(canAfford ? Theme.gold : Color.clear)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().strokeBorder(canAfford ? Color.clear : Theme.bloodRed.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.05, green: 0.08, blue: 0.07))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .shadow(color: flashSuccess ? Theme.gold.opacity(0.5) : .clear, radius: 12)
            .scaleEffect(flashFail ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: flashFail)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(owned)
    }

    private var borderColor: Color {
        if flashSuccess { return Theme.gold }
        if flashFail { return Theme.bloodRed }
        if owned { return Theme.gold.opacity(0.5) }
        return Theme.leafGreen.opacity(0.3)
    }
}
