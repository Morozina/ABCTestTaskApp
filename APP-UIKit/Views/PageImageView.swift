import UIKit

final class PageImageView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let iconImageView = UIImageView()
    private var iconInset: CGFloat = 40

    var cornerRadius: CGFloat = AppMetrics.carouselCornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
    }

    func configure(with page: Page, iconInset: CGFloat = 40, iconOverride: String? = nil) {
        gradientLayer.colors = [page.gradientStart.uiColor.cgColor, page.gradientEnd.uiColor.cgColor]
        iconImageView.image = UIImage(systemName: iconOverride ?? page.imageSymbol)
        self.iconInset = iconInset
        setNeedsLayout()
        accessibilityLabel = page.title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let size = max(bounds.width, bounds.height)
        let iconSize = max(0, size - iconInset * 2)
        iconImageView.frame = CGRect(
            x: (bounds.width - iconSize) / 2,
            y: (bounds.height - iconSize) / 2,
            width: iconSize,
            height: iconSize
        )
    }

    private func setupHierarchy() {
        isAccessibilityElement = true
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        layer.masksToBounds = true

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.white.withAlphaComponent(0.35)
        addSubview(iconImageView)
    }
}
