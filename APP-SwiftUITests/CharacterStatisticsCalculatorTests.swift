import XCTest
@testable import APP_SwiftUI

final class CharacterStatisticsCalculatorTests: XCTestCase {

    private let calculator = CharacterStatisticsCalculator()

    func testEmptyItemsReturnsEmptyResult() {
        let result = calculator.topCharacters(in: [])
        XCTAssertTrue(result.isEmpty)
    }

    func testIgnoresNonLetterCharacters() {
        let items = [
            ListItem(title: "1234 !!!", subtitle: "...", imageSymbol: "x")
        ]
        let result = calculator.topCharacters(in: items)
        XCTAssertTrue(result.isEmpty)
    }

    func testCountsAreCaseInsensitive() {
        let items = [
            ListItem(title: "AaA", subtitle: "...", imageSymbol: "x")
        ]
        let result = calculator.topCharacters(in: items, limit: 1)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.character, "a")
        XCTAssertEqual(result.first?.count, 3)
    }

    func testSpecExample() {
        let items = [
            ListItem(title: "apple", subtitle: "", imageSymbol: "x"),
            ListItem(title: "banana", subtitle: "", imageSymbol: "x"),
            ListItem(title: "orange", subtitle: "", imageSymbol: "x"),
            ListItem(title: "blueberry", subtitle: "", imageSymbol: "x"),
        ]
        let result = calculator.topCharacters(in: items)
        XCTAssertEqual(result.map(\.character), ["a", "e", "b"])
        XCTAssertEqual(result.map(\.count), [5, 4, 3])
    }

    func testRespectsLimit() {
        let items = [
            ListItem(title: "abcdef", subtitle: "", imageSymbol: "x"),
        ]
        let result = calculator.topCharacters(in: items, limit: 2)
        XCTAssertEqual(result.count, 2)
    }

    func testTieBreakerIsAlphabetical() {
        let items = [
            ListItem(title: "ab", subtitle: "", imageSymbol: "x"),
        ]
        let result = calculator.topCharacters(in: items, limit: 2)
        XCTAssertEqual(result.map(\.character), ["a", "b"])
    }

    func testUnicodeLettersAreCounted() {
        let items = [
            ListItem(title: "Białowieża", subtitle: "", imageSymbol: "x"),
        ]
        let result = calculator.topCharacters(in: items, limit: 10)
        XCTAssertTrue(result.contains { $0.character == "a" && $0.count == 2 })
        XCTAssertTrue(result.contains { $0.character == "ł" })
        XCTAssertTrue(result.contains { $0.character == "ż" })
    }
}
