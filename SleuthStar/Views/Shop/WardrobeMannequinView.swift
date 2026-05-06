import SwiftUI

/// Detective figure visualization — a Pillow-rendered noir illustration as the base,
/// with each owned wardrobe item layered on top as a transparent PNG overlay.
struct WardrobeMannequinView: View {
    let ownedIds: Set<String>

    private var ownedCount: Int {
        ShopRepository.items(in: .clothing).filter { ownedIds.contains($0.id) }.count
    }

    private var totalCount: Int {
        ShopRepository.items(in: .clothing).count
    }

    private func owns(_ id: String) -> Bool { ownedIds.contains(id) }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("YOUR DETECTIVE")
                        .font(.system(size: 10, weight: .heavy, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(Theme.gold)
                    Text("\(ownedCount) of \(totalCount) pieces worn")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Theme.leafGreen.opacity(0.8))
                }
                Spacer()
            }

            ZStack {
                // Spotlight backdrop
                RadialGradient(
                    colors: [Theme.gold.opacity(0.18), .clear],
                    center: UnitPoint(x: 0.5, y: 0.4),
                    startRadius: 0,
                    endRadius: 200
                )

                // Floor shadow
                Ellipse()
                    .fill(Color.black.opacity(0.55))
                    .frame(width: 130, height: 16)
                    .offset(y: 142)
                    .blur(radius: 6)

                // Layered detective figure — order matters (back to front)
                ZStack {
                    layerImage("DetectiveBase")
                    if owns("wd-suit") { layerImage("WardrobeSuit") }
                    if owns("wd-trench") { layerImage("WardrobeTrench") }
                    if owns("wd-badge") { layerImage("WardrobeBadge") }
                    if owns("wd-pocket-watch") { layerImage("WardrobeWatch") }
                    if owns("wd-gloves") { layerImage("WardrobeGloves") }
                    if owns("wd-fedora") { layerImage("WardrobeFedora") }
                }
                .frame(width: 200, height: 300)
            }
            .frame(height: 320)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.04, green: 0.06, blue: 0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Theme.leafGreen.opacity(0.25), lineWidth: 1)
            )
        }
    }

    private func layerImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .interpolation(.high)
            .aspectRatio(contentMode: .fit)
    }
}
