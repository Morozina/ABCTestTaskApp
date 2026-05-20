import UIKit

final class CarouselCell: UICollectionViewCell {

    static let reuseIdentifier = "CarouselCell"

    private let pageImageView = PageImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
    }

    func configure(with page: Page) {
        pageImageView.configure(with: page)
    }

    private func setupHierarchy() {
        contentView.backgroundColor = .clear
        pageImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageImageView)

        NSLayoutConstraint.activate([
            pageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
