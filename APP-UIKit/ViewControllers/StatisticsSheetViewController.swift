import UIKit

final class StatisticsSheetViewController: UIViewController {

    private let statistics: PageStatistics
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    init(statistics: PageStatistics) {
        self.statistics = statistics
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        renderStatistics()
    }

    private func setupHierarchy() {
        titleLabel.font = scaledMonospacedFont(for: .title3, weight: .semibold)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = AppColor.primaryText
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),

            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        ])
    }

    private func renderStatistics() {
        let itemsText = String.localizedStringWithFormat("%lld items".localized, statistics.itemCount)
        titleLabel.text = String.localizedStringWithFormat(
            "List %lld (%@)".localized,
            statistics.pageNumber,
            itemsText
        )

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if statistics.topCharacters.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No characters to show".localized
            emptyLabel.font = .preferredFont(forTextStyle: .body)
            emptyLabel.adjustsFontForContentSizeCategory = true
            emptyLabel.textColor = AppColor.secondaryText
            stackView.addArrangedSubview(emptyLabel)
            return
        }

        for entry in statistics.topCharacters {
            stackView.addArrangedSubview(makeRow(for: entry))
        }
    }

    private func makeRow(for entry: CharacterCount) -> UIView {
        let label = UILabel()
        label.attributedText = makeAttributedString(for: entry)
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    private func makeAttributedString(for entry: CharacterCount) -> NSAttributedString {
        let result = NSMutableAttributedString()

        result.append(NSAttributedString(
            string: String(entry.character),
            attributes: [
                .font: scaledMonospacedFont(for: .body, weight: .medium),
                .foregroundColor: AppColor.primaryText,
            ]
        ))
        result.append(NSAttributedString(
            string: " = ",
            attributes: [
                .font: scaledMonospacedFont(for: .body, weight: .regular),
                .foregroundColor: AppColor.secondaryText,
            ]
        ))
        result.append(NSAttributedString(
            string: "\(entry.count)",
            attributes: [
                .font: scaledMonospacedFont(for: .body, weight: .regular),
                .foregroundColor: AppColor.primaryText,
            ]
        ))

        return result
    }

    private func scaledMonospacedFont(for style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let base = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
        return metrics.scaledFont(for: base)
    }
}
