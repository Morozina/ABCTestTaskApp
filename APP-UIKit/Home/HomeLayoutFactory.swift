import UIKit

@MainActor
struct HomeLayoutFactory {

    let searchHeaderHeight: CGFloat
    let onPageScrollChanged: (Int) -> Void

    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = HomeSection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .carousel: return makeCarouselSection()
            case .indicator: return makeIndicatorSection()
            case .items: return makeItemsSection()
            }
        }
    }

    private func makeCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppMetrics.horizontalPadding,
            bottom: 0,
            trailing: AppMetrics.horizontalPadding
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(AppMetrics.carouselHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { _, offset, environment in
            let pageWidth = environment.container.contentSize.width
            guard pageWidth > 0 else { return }
            let index = Int(round(offset.x / pageWidth))
            onPageScrollChanged(index)
        }
        return section
    }

    private func makeIndicatorSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(AppMetrics.pageIndicatorHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 4, trailing: 0)
        return section
    }

    private func makeItemsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(AppMetrics.listItemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppMetrics.horizontalPadding,
            bottom: 0,
            trailing: AppMetrics.horizontalPadding
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(AppMetrics.listItemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = AppMetrics.itemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: searchHeaderHeight + AppMetrics.itemSpacing,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        return section
    }
}
