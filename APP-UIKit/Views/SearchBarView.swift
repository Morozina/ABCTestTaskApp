import UIKit

@MainActor
protocol SearchBarViewDelegate: AnyObject {
    func searchBarView(_ searchBarView: SearchBarView, didChangeText text: String)
    func searchBarViewDidSubmit(_ searchBarView: SearchBarView)
}

final class SearchBarView: UIView {

    weak var delegate: SearchBarViewDelegate?

    private let fieldContainer = UIView()
    private let iconImageView = UIImageView()
    private let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
    }

    func setText(_ text: String) {
        guard textField.text != text else { return }
        textField.text = text
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    private func setupHierarchy() {
        backgroundColor = AppColor.screenBackground

        fieldContainer.backgroundColor = AppColor.searchFieldBackground
        fieldContainer.layer.cornerRadius = AppMetrics.searchFieldCornerRadius
        fieldContainer.layer.cornerCurve = .continuous
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fieldContainer)

        iconImageView.image = UIImage(systemName: "magnifyingglass")
        iconImageView.tintColor = AppColor.searchFieldPlaceholder
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(iconImageView)

        textField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "Search"),
            attributes: [
                .foregroundColor: AppColor.searchFieldPlaceholder,
                .font: UIFont.preferredFont(forTextStyle: .body),
            ]
        )
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.textColor = AppColor.primaryText
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .search
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(textField)

        NSLayoutConstraint.activate([
            fieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppMetrics.horizontalPadding),
            fieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppMetrics.horizontalPadding),
            fieldContainer.topAnchor.constraint(equalTo: topAnchor, constant: AppMetrics.searchBarVerticalPadding),
            fieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppMetrics.searchBarVerticalPadding),

            iconImageView.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: fieldContainer.heightAnchor),
        ])
    }

    @objc private func textFieldDidChange() {
        delegate?.searchBarView(self, didChangeText: textField.text ?? "")
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarViewDidSubmit(self)
        textField.resignFirstResponder()
        return true
    }
}
