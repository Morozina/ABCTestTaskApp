import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AppColor.screenBackground
                .ignoresSafeArea()

            listContent

            FloatingActionButton {
                viewModel.presentStatistics()
            }
            .padding(.trailing, AppMetrics.horizontalPadding)
            .padding(.bottom, AppMetrics.horizontalPadding)
        }
        .task { await viewModel.loadInitialContent() }
        .sheet(isPresented: $viewModel.isStatisticsSheetPresented) {
            if let statistics = viewModel.currentPageStatistics {
                StatisticsSheetView(statistics: statistics)
            }
        }
    }

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    carouselWithIndicator
                        .padding(.top, AppMetrics.sectionSpacing)
                        .padding(.bottom, AppMetrics.sectionSpacing)
                }

                Section {
                    ForEach(viewModel.filteredItems) { item in
                        if let page = viewModel.currentPage {
                            ListItemRow(item: item, page: page)
                                .padding(.horizontal, AppMetrics.horizontalPadding)
                                .padding(.vertical, AppMetrics.itemSpacing / 2)
                        }
                    }

                    if viewModel.filteredItems.isEmpty && !viewModel.pages.isEmpty {
                        emptyState
                            .padding(.top, AppMetrics.itemSpacing)
                    }

                    Color.clear
                        .frame(height: AppMetrics.floatingActionButtonSize + AppMetrics.horizontalPadding)
                } header: {
                    SearchBarView(text: $viewModel.searchText)
                        .padding(.horizontal, AppMetrics.horizontalPadding)
                        .padding(.vertical, AppMetrics.searchBarVerticalPadding)
                        .background(.thinMaterial)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .padding(.top, 1)
    }

    private var carouselWithIndicator: some View {
        VStack(spacing: 12) {
            CarouselView(pages: viewModel.pages, currentIndex: $viewModel.currentPageIndex)

            PageIndicatorView(
                count: viewModel.pages.count,
                currentIndex: viewModel.currentPageIndex
            )
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(AppColor.searchFieldPlaceholder)
            Text("No matches for \"\(viewModel.searchText)\"")
                .font(.callout)
                .foregroundStyle(AppColor.secondaryText)
        }
        .padding(.top, 40)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}
