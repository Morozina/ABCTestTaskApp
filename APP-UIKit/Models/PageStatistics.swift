import Foundation

struct PageStatistics: Hashable, Sendable {
    let pageNumber: Int
    let itemCount: Int
    let topCharacters: [CharacterCount]
}
