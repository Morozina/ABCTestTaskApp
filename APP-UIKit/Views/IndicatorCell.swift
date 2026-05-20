import UIKit

final class IndicatorCell: UICollectionViewCell {

    static let reuseIdentifier = "IndicatorCell"

    private let indicatorView = PageIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
    }

    func configure(numberOfPages: Int, currentIndex: Int) {
        indicatorView.configure(numberOfPages: numberOfPages, currentIndex: currentIndex)
    }

    func update(currentIndex: Int) {
        indicatorView.update(currentIndex: currentIndex)
    }

    private func setupHierarchy() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            indicatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
