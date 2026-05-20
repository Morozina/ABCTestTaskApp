import Foundation

struct CharacterCount: Identifiable, Hashable, Sendable {
    var id: Character { character }
    let character: Character
    let count: Int
}
