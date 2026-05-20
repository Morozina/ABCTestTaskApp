import Foundation

enum HomeCellItem: Hashable, Sendable {
    case carousel(Page)
    case indicator
    case listItem(ListItem)
}
