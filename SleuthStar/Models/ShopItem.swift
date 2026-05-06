import Foundation

struct ShopItem: Identifiable, Codable, Hashable {
    let id: String
    let category: ShopCategory
    let name: String
    let description: String
    let iconName: String
    let price: Int
    let perk: String
    let analysisTool: AnalysisTool?
    let comingSoon: Bool

    init(
        id: String,
        category: ShopCategory,
        name: String,
        description: String,
        iconName: String,
        price: Int,
        perk: String,
        analysisTool: AnalysisTool? = nil,
        comingSoon: Bool = false
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.description = description
        self.iconName = iconName
        self.price = price
        self.perk = perk
        self.analysisTool = analysisTool
        self.comingSoon = comingSoon
    }
}
