import UIKit

final class ListItemCell: UICollectionViewCell {

    static let reuseIdentifier = "ListItemCell"

    private let cardView = UIView()
    private let thumbnailView = PageImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
    }

    func configure(with item: ListItem, page: Page) {
        thumbnailView.cornerRadius = AppMetrics.thumbnailCornerRadius
        thumbnailView.configure(with: page, iconInset: 14, iconOverride: item.imageSymbol)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        accessibilityLabel = "\(item.title), \(item.subtitle)"
    }

    private func setupHierarchy() {
        isAccessibilityElement = true
        contentView.backgroundColor = .clear

        cardView.backgroundColor = AppColor.cardBackground
        cardView.layer.cornerRadius = AppMetrics.cardCornerRadius
        cardView.layer.cornerCurve = .continuous
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(thumbnailView)

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = AppColor.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textColor = AppColor.secondaryText
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            thumbnailView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            thumbnailView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            thumbnailView.widthAnchor.constraint(equalToConstant: AppMetrics.thumbnailSize),
            thumbnailView.heightAnchor.constraint(equalToConstant: AppMetrics.thumbnailSize),

            titleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -2),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: cardView.centerYAnchor, constant: 2),
        ])
    }
}
