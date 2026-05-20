import UIKit

final class FloatingActionButton: UIButton {

    init() {
        super.init(frame: .zero)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    private func setupAppearance() {
        backgroundColor = AppColor.floatingActionButton
        tintColor = AppColor.floatingActionButtonIcon
        accessibilityLabel = "Show statistics".localized

        let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let baseImage = UIImage(systemName: "ellipsis", withConfiguration: configuration)
        let rotated = baseImage?.withRenderingMode(.alwaysTemplate).rotated90Clockwise()
        setImage(rotated, for: .normal)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.20
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}

private extension UIImage {

    func rotated90Clockwise() -> UIImage? {
        let rotatedSize = CGSize(width: size.height, height: size.width)
        let renderer = UIGraphicsImageRenderer(size: rotatedSize)
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            cgContext.rotate(by: .pi / 2)
            draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        }.withRenderingMode(.alwaysTemplate)
    }
}
