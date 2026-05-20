import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel: HomeViewModelInput {

    private(set) var pages: [Page] = []
    var currentPageIndex: Int = 0
    var searchText: String = ""
    var isStatisticsSheetPresented: Bool = false

    @ObservationIgnored
    private let pageDataProvider: PageDataProvider
    @ObservationIgnored
    private let statisticsCalculator: CharacterStatisticsCalculating

    init(
        pageDataProvider: PageDataProvider = LocalPageDataProvider(),
        statisticsCalculator: CharacterStatisticsCalculating = CharacterStatisticsCalculator()
    ) {
        self.pageDataProvider = pageDataProvider
        self.statisticsCalculator = statisticsCalculator
    }

    var currentPage: Page? {
        guard pages.indices.contains(currentPageIndex) else { return nil }
        return pages[currentPageIndex]
    }

    var filteredItems: [ListItem] {
        guard let items = currentPage?.items else { return [] }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return items }
        return items.filter { item in
            item.title.localizedCaseInsensitiveContains(query) ||
            item.subtitle.localizedCaseInsensitiveContains(query)
        }
    }

    var currentPageStatistics: PageStatistics? {
        guard let page = currentPage else { return nil }
        return PageStatistics(
            pageNumber: currentPageIndex + 1,
            itemCount: page.items.count,
            topCharacters: statisticsCalculator.topCharacters(in: page.items)
        )
    }

    func loadInitialContent() async {
        guard pages.isEmpty else { return }
        let loaded = (try? await pageDataProvider.loadPages()) ?? []
        pages = loaded
    }

    func presentStatistics() {
        isStatisticsSheetPresented = true
    }
}
