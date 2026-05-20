import Foundation

protocol CharacterStatisticsCalculating: Sendable {
    func topCharacters(in items: [ListItem], limit: Int) -> [CharacterCount]
}

extension CharacterStatisticsCalculating {
    func topCharacters(in items: [ListItem]) -> [CharacterCount] {
        topCharacters(in: items, limit: 3)
    }
}

struct CharacterStatisticsCalculator: CharacterStatisticsCalculating {

    func topCharacters(in items: [ListItem], limit: Int) -> [CharacterCount] {
        var counts: [Character: Int] = [:]

        for item in items {
            for character in item.title.lowercased() where character.isLetter {
                counts[character, default: 0] += 1
            }
        }

        return counts
            .sorted { lhs, rhs in
                if lhs.value != rhs.value { return lhs.value > rhs.value }
                return lhs.key < rhs.key
            }
            .prefix(limit)
            .map { CharacterCount(character: $0.key, count: $0.value) }
    }
}
