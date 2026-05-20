import UIKit

final class PageIndicatorView: UIView {

    private let stackView = UIStackView()
    private var dots: [UIView] = []
    private var currentIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
    }

    func configure(numberOfPages: Int, currentIndex: Int) {
        guard dots.count != numberOfPages else {
            update(currentIndex: currentIndex)
            return
        }
        dots.forEach { $0.removeFromSuperview() }
        dots = (0..<numberOfPages).map { _ in makeDot() }
        dots.forEach { stackView.addArrangedSubview($0) }
        update(currentIndex: currentIndex)
    }

    func update(currentIndex: Int) {
        self.currentIndex = currentIndex
        for (index, dot) in dots.enumerated() {
            dot.backgroundColor = (index == currentIndex)
                ? AppColor.pageIndicatorActive
                : AppColor.pageIndicatorInactive
        }
    }

    private func setupHierarchy() {
        isAccessibilityElement = true
        stackView.axis = .horizontal
        stackView.spacing = AppMetrics.pageIndicatorSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func makeDot() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = AppMetrics.pageIndicatorDotSize / 2
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: AppMetrics.pageIndicatorDotSize),
            view.heightAnchor.constraint(equalToConstant: AppMetrics.pageIndicatorDotSize),
        ])
        return view
    }
}
