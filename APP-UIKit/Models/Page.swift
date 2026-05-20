import Foundation

struct Page: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let imageSymbol: String
    let gradientStart: GradientColor
    let gradientEnd: GradientColor
    let items: [ListItem]

    init(
        id: UUID = UUID(),
        title: String,
        imageSymbol: String,
        gradientStart: GradientColor,
        gradientEnd: GradientColor,
        items: [ListItem]
    ) {
        self.id = id
        self.title = title
        self.imageSymbol = imageSymbol
        self.gradientStart = gradientStart
        self.gradientEnd = gradientEnd
        self.items = items
    }
}
