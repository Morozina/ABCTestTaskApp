import UIKit

@MainActor
final class HomeDataSource {

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<HomeSection, HomeCellItem>

    private let dataSource: DiffableDataSource

    init(
        collectionView: UICollectionView,
        currentPageProvider: @escaping () -> Page?,
        pagesCountProvider: @escaping () -> Int,
        currentIndexProvider: @escaping () -> Int
    ) {
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
        collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCell.reuseIdentifier)
        collectionView.register(ListItemCell.self, forCellWithReuseIdentifier: ListItemCell.reuseIdentifier)

        self.dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .carousel(let page):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CarouselCell.reuseIdentifier,
                    for: indexPath
                ) as? CarouselCell else { return UICollectionViewCell() }
                cell.configure(with: page)
                return cell
            case .indicator:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: IndicatorCell.reuseIdentifier,
                    for: indexPath
                ) as? IndicatorCell else { return UICollectionViewCell() }
                cell.configure(numberOfPages: pagesCountProvider(), currentIndex: currentIndexProvider())
                return cell
            case .listItem(let listItem):
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListItemCell.reuseIdentifier,
                        for: indexPath
                    ) as? ListItemCell,
                    let page = currentPageProvider()
                else { return UICollectionViewCell() }
                cell.configure(with: listItem, page: page)
                return cell
            }
        }
    }

    func applySnapshot(pages: [Page], items: [ListItem], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeCellItem>()
        snapshot.appendSections(HomeSection.allCases)
        snapshot.appendItems(pages.map(HomeCellItem.carousel), toSection: .carousel)
        if !pages.isEmpty {
            snapshot.appendItems([.indicator], toSection: .indicator)
        }
        snapshot.appendItems(items.map(HomeCellItem.listItem), toSection: .items)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func indicatorCell(in collectionView: UICollectionView) -> IndicatorCell? {
        guard let indexPath = dataSource.indexPath(for: .indicator) else { return nil }
        return collectionView.cellForItem(at: indexPath) as? IndicatorCell
    }
}
