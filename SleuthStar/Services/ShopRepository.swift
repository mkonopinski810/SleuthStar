import Foundation

enum ShopRepository {
    static let allItems: [ShopItem] = [
        // Equipment
        ShopItem(
            id: "eq-magnifier",
            category: .equipment,
            name: "Brass Magnifier",
            description: "A heavier glass. Reveals fine surface details and visible traces.",
            iconName: "magnifyingglass.circle.fill",
            price: 150,
            perk: "Run a Magnifier analysis on collected evidence",
            analysisTool: .magnifier
        ),
        ShopItem(
            id: "eq-uv-light",
            category: .equipment,
            name: "UV Flashlight",
            description: "Picks up biological traces, hidden writing, and fluids.",
            iconName: "flashlight.on.fill",
            price: 320,
            perk: "Run a UV analysis on collected evidence",
            analysisTool: .uvLight
        ),
        ShopItem(
            id: "eq-evidence-kit",
            category: .equipment,
            name: "Evidence Kit",
            description: "Lined briefcase with field-lab vials. Sends out for chemical work.",
            iconName: "briefcase.fill",
            price: 480,
            perk: "Run a Lab analysis on collected evidence",
            analysisTool: .evidenceKit
        ),
        ShopItem(
            id: "eq-polaroid",
            category: .equipment,
            name: "Polaroid Camera",
            description: "Snaps every collected piece. Stays in your case file forever.",
            iconName: "camera.fill",
            price: 550,
            perk: "Photographs every collected exhibit"
        ),
        ShopItem(
            id: "eq-lockpick",
            category: .equipment,
            name: "Lockpick Set",
            description: "Discreet tension wrench, six picks. Discretion guaranteed.",
            iconName: "key.fill",
            price: 720,
            perk: "Unlocks locked rooms in scenes (coming soon)",
            comingSoon: true
        ),
        ShopItem(
            id: "eq-print-kit",
            category: .equipment,
            name: "Latent Print Kit",
            description: "Powder, brushes, lift cards. Every print becomes a real lead.",
            iconName: "hand.tap.fill",
            price: 1200,
            perk: "Boosts Magnifier on prints — adds AFIS hits"
        ),
        ShopItem(
            id: "eq-microscope",
            category: .equipment,
            name: "Field Microscope",
            description: "Optical scope. Picks up what nobody else sees.",
            iconName: "scope",
            price: 2800,
            perk: "Unlocks microscopic detail on lab work"
        ),

        // Wardrobe
        ShopItem(
            id: "wd-trench",
            category: .clothing,
            name: "Charcoal Trench",
            description: "A long charcoal coat. The lapels keep the rain off.",
            iconName: "figure.stand",
            price: 240,
            perk: "+5% witness cooperation"
        ),
        ShopItem(
            id: "wd-fedora",
            category: .clothing,
            name: "Felt Fedora",
            description: "Wide brim. Casts a useful shadow over the eyes.",
            iconName: "graduationcap.fill",
            price: 180,
            perk: "Bonus styling"
        ),
        ShopItem(
            id: "wd-gloves",
            category: .clothing,
            name: "Leather Gloves",
            description: "Soft, lined, and never leave a print of their own.",
            iconName: "hand.raised.fill",
            price: 120,
            perk: "Keep the scene clean"
        ),
        ShopItem(
            id: "wd-pocket-watch",
            category: .clothing,
            name: "Pocket Watch",
            description: "Always on time. Always quietly judging the witness.",
            iconName: "clock.fill",
            price: 320,
            perk: "Cosmetic — keeps you punctual"
        ),
        ShopItem(
            id: "wd-badge",
            category: .clothing,
            name: "Detective Badge",
            description: "Brass, weighted. Witnesses straighten up when it appears.",
            iconName: "shield.lefthalf.filled",
            price: 650,
            perk: "+10% reward on guilty verdicts"
        ),
        ShopItem(
            id: "wd-suit",
            category: .clothing,
            name: "Three-Piece Suit",
            description: "Pinstripe wool. The bench takes you seriously.",
            iconName: "person.fill",
            price: 1400,
            perk: "−20% fine on not-guilty verdicts"
        ),

        // Assistant
        ShopItem(
            id: "as-rookie",
            category: .assistant,
            name: "Rookie · Junie Park",
            description: "Sharp, eager, takes notes you don't have to.",
            iconName: "person.crop.circle.fill",
            price: 600,
            perk: "Auto-collects 1 obvious clue per scene"
        ),
        ShopItem(
            id: "as-driver",
            category: .assistant,
            name: "Driver · Kit Avery",
            description: "Fast hands, faster wheels. Knows every shortcut in the city.",
            iconName: "car.fill",
            price: 980,
            perk: "Skip intro cutscenes (cosmetic)"
        ),
        ShopItem(
            id: "as-forensic",
            category: .assistant,
            name: "Forensic · Dr. Vance",
            description: "Worked at the crime lab. Reads what the evidence is saying.",
            iconName: "cross.case.fill",
            price: 1400,
            perk: "Reveals each piece's strength as evidence",
            analysisTool: .forensicAssistant
        ),
        ShopItem(
            id: "as-tail",
            category: .assistant,
            name: "Tail · Sam Patel",
            description: "Surveillance specialist. Sees what others walk past.",
            iconName: "binoculars.fill",
            price: 1800,
            perk: "Reveals one extra evidence sparkle per scene"
        ),
        ShopItem(
            id: "as-cipher",
            category: .assistant,
            name: "Cipher · Eli Ríos",
            description: "Codebreaker. If a note has a second meaning, they'll find it.",
            iconName: "character.book.closed.fill",
            price: 2600,
            perk: "Notes self-translate (extra UV finding)"
        ),
        ShopItem(
            id: "as-informant",
            category: .assistant,
            name: "Informant · Cricket",
            description: "Knows everyone's business. Charges in coffee.",
            iconName: "ear.fill",
            price: 2200,
            perk: "Reveals incriminating evidence on contact"
        )
    ]

    static func items(in category: ShopCategory) -> [ShopItem] {
        allItems.filter { $0.category == category }
    }

    static func byId(_ id: String) -> ShopItem? {
        allItems.first { $0.id == id }
    }
}
