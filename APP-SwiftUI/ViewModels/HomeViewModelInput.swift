import Foundation

@MainActor
protocol HomeViewModelInput: AnyObject {
    var pages: [Page] { get }
    var currentPageIndex: Int { get set }
    var searchText: String { get set }
    var isStatisticsSheetPresented: Bool { get set }
    var currentPage: Page? { get }
    var filteredItems: [ListItem] { get }
    var currentPageStatistics: PageStatistics? { get }

    func loadInitialContent() async
    func presentStatistics()
}
