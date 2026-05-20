import Foundation

struct ListItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageSymbol: String

    init(id: UUID = UUID(), title: String, subtitle: String, imageSymbol: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageSymbol = imageSymbol
    }
}
