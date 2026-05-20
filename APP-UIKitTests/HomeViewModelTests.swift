import XCTest
@testable import APP_UIKit

@MainActor
final class HomeViewModelTests: XCTestCase {

    private func makePages() -> [Page] {
        [
            Page(
                title: "Letters",
                imageSymbol: "a.square",
                gradientStart: GradientColor(red: 0, green: 0, blue: 0),
                gradientEnd: GradientColor(red: 1, green: 1, blue: 1),
                items: [
                    ListItem(title: "Alpha", subtitle: "first", imageSymbol: "a.square"),
                    ListItem(title: "Beta", subtitle: "second", imageSymbol: "b.square"),
                    ListItem(title: "Gamma", subtitle: "third", imageSymbol: "c.square"),
                ]
            ),
            Page(
                title: "Numbers",
                imageSymbol: "1.square",
                gradientStart: GradientColor(red: 0, green: 0, blue: 0),
                gradientEnd: GradientColor(red: 1, green: 1, blue: 1),
                items: [
                    ListItem(title: "One", subtitle: "1", imageSymbol: "1.square"),
                    ListItem(title: "Two", subtitle: "2", imageSymbol: "2.square"),
                ]
            ),
        ]
    }

    private func makeViewModel() async -> HomeViewModel {
        let viewModel = HomeViewModel(pageDataProvider: StubPageDataProvider(pages: makePages()))
        await viewModel.loadInitialContent()
        return viewModel
    }

    func testStartsOnFirstPage() async {
        let viewModel = await makeViewModel()
        XCTAssertEqual(viewModel.currentPageIndex, 0)
        XCTAssertEqual(viewModel.currentPage?.title, "Letters")
    }

    func testFilteredItemsReturnsAllWhenSearchEmpty() async {
        let viewModel = await makeViewModel()
        XCTAssertEqual(viewModel.filteredItems.count, 3)
    }

    func testFilteredItemsByTitle() async {
        let viewModel = await makeViewModel()
        viewModel.setSearchText("alp")
        XCTAssertEqual(viewModel.filteredItems.map(\.title), ["Alpha"])
    }

    func testFilteredItemsBySubtitle() async {
        let viewModel = await makeViewModel()
        viewModel.setSearchText("second")
        XCTAssertEqual(viewModel.filteredItems.map(\.title), ["Beta"])
    }

    func testFilteredItemsIsCaseInsensitive() async {
        let viewModel = await makeViewModel()
        viewModel.setSearchText("BETA")
        XCTAssertEqual(viewModel.filteredItems.map(\.title), ["Beta"])
    }

    func testFilteredItemsTrimsWhitespace() async {
        let viewModel = await makeViewModel()
        viewModel.setSearchText("   ")
        XCTAssertEqual(viewModel.filteredItems.count, 3)
    }

    func testChangingPageUpdatesItems() async {
        let viewModel = await makeViewModel()
        viewModel.setCurrentPage(1)
        XCTAssertEqual(viewModel.currentPage?.title, "Numbers")
        XCTAssertEqual(viewModel.filteredItems.count, 2)
    }

    func testCurrentPageStatistics() async {
        let viewModel = await makeViewModel()
        let stats = viewModel.currentPageStatistics
        XCTAssertEqual(stats?.pageNumber, 1)
        XCTAssertEqual(stats?.itemCount, 3)
        XCTAssertEqual(stats?.topCharacters.isEmpty, false)
    }

    func testSetCurrentPageIgnoresOutOfBounds() async {
        let viewModel = await makeViewModel()
        viewModel.setCurrentPage(99)
        XCTAssertEqual(viewModel.currentPageIndex, 0)
    }

    func testLoadInitialContentIsIdempotent() async {
        let provider = StubPageDataProvider(pages: makePages())
        let viewModel = HomeViewModel(pageDataProvider: provider)

        await viewModel.loadInitialContent()
        await viewModel.loadInitialContent()

        XCTAssertEqual(provider.loadCount, 1)
    }

    func testLoadInitialContentFallsBackToEmptyOnFailure() async {
        let viewModel = HomeViewModel(pageDataProvider: ThrowingPageDataProvider())
        await viewModel.loadInitialContent()
        XCTAssertTrue(viewModel.pages.isEmpty)
        XCTAssertNil(viewModel.currentPage)
        XCTAssertNil(viewModel.currentPageStatistics)
    }
}

private final class StubPageDataProvider: PageDataProvider, @unchecked Sendable {
    private let pages: [Page]
    private(set) var loadCount = 0

    init(pages: [Page]) {
        self.pages = pages
    }

    func loadPages() async throws -> [Page] {
        loadCount += 1
        return pages
    }
}

private struct ThrowingPageDataProvider: PageDataProvider {
    struct LoadError: Error {}
    func loadPages() async throws -> [Page] { throw LoadError() }
}
