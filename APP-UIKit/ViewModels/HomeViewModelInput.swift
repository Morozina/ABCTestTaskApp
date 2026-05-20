import Foundation

@MainActor
protocol HomeViewModelInput: AnyObject {
    var pages: [Page] { get }
    var currentPageIndex: Int { get }
    var searchText: String { get }
    var currentPage: Page? { get }
    var filteredItems: [ListItem] { get }
    var currentPageStatistics: PageStatistics? { get }

    func loadInitialContent() async
    func setCurrentPage(_ index: Int)
    func setSearchText(_ text: String)
}
