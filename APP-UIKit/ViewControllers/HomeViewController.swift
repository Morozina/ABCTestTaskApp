import UIKit
import Observation

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModelInput

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: HomeDataSource = makeDataSource()
    private let searchBar = SearchBarView()
    private let floatingButton = FloatingActionButton()
    private var searchBarTopConstraint: NSLayoutConstraint?

    private var defaultCollectionBottomInset: CGFloat {
        AppMetrics.floatingActionButtonSize + AppMetrics.horizontalPadding * 2
    }

    private var itemsSectionContentTop: CGFloat {
        AppMetrics.carouselHeight
            + 12
            + AppMetrics.pageIndicatorHeight
            + 4
    }

    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        installDismissKeyboardGesture()
        observeKeyboard()
        observeViewModel()
        Task { @MainActor in
            await viewModel.loadInitialContent()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSearchBarPosition()
    }

    private func setupHierarchy() {
        view.backgroundColor = AppColor.screenBackground

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        view.addSubview(searchBar)

        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingButton)

        let searchBarTop = searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        searchBarTopConstraint = searchBarTop

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: AppMetrics.searchHeaderHeight),
            searchBarTop,

            floatingButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -AppMetrics.horizontalPadding
            ),
            floatingButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -AppMetrics.horizontalPadding
            ),
            floatingButton.widthAnchor.constraint(equalToConstant: AppMetrics.floatingActionButtonSize),
            floatingButton.heightAnchor.constraint(equalToConstant: AppMetrics.floatingActionButtonSize),
        ])
    }

    private func observeViewModel() {
        withObservationTracking { [viewModel] in
            _ = viewModel.pages
            _ = viewModel.currentPageIndex
            _ = viewModel.searchText
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                self?.refreshUI()
                self?.observeViewModel()
            }
        }
    }

    private func refreshUI() {
        dataSource.applySnapshot(
            pages: viewModel.pages,
            items: viewModel.filteredItems,
            animated: false
        )
        searchBar.setText(viewModel.searchText)
        refreshIndicator()
    }

    private func refreshIndicator() {
        guard let cell = dataSource.indicatorCell(in: collectionView) else { return }
        cell.update(currentIndex: viewModel.currentPageIndex)
    }

    private func updateSearchBarPosition() {
        let contentOffsetY = collectionView.contentOffset.y
        let offset = itemsSectionContentTop - contentOffsetY
        let constraint = max(0, offset)
        searchBarTopConstraint?.constant = constraint
    }

    private func installDismissKeyboardGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(gesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func observeKeyboard() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(handleKeyboardChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(handleKeyboardHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func handleKeyboardChange(_ notification: Notification) {
        guard
            let endFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let endFrame = view.convert(endFrameValue.cgRectValue, from: nil)
        let coveredByKeyboard = max(0, view.bounds.maxY - endFrame.minY)
        let inset = max(defaultCollectionBottomInset, coveredByKeyboard + AppMetrics.itemSpacing)

        animateInsetChange(to: inset, duration: duration, curve: curveRaw)
    }

    @objc private func handleKeyboardHide(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        animateInsetChange(to: defaultCollectionBottomInset, duration: duration, curve: curveRaw)
    }

    private func animateInsetChange(to inset: CGFloat, duration: TimeInterval, curve: UInt) {
        let options = UIView.AnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.collectionView.contentInset.bottom = inset
            self.collectionView.verticalScrollIndicatorInsets.bottom = inset
        }
    }

    @objc private func floatingButtonTapped() {
        guard let statistics = viewModel.currentPageStatistics else { return }
        let sheet = StatisticsSheetViewController(statistics: statistics)
        if let controller = sheet.sheetPresentationController {
            controller.detents = [.medium()]
            controller.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }
}

private extension HomeViewController {

    func makeCollectionView() -> UICollectionView {
        let factory = HomeLayoutFactory(
            searchHeaderHeight: AppMetrics.searchHeaderHeight
        ) { [weak self] index in
            Task { @MainActor [weak self] in
                self?.viewModel.setCurrentPage(index)
            }
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: factory.makeLayout())
        view.backgroundColor = AppColor.screenBackground
        view.showsVerticalScrollIndicator = false
        view.keyboardDismissMode = .interactive
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = UIEdgeInsets(
            top: AppMetrics.sectionSpacing,
            left: 0,
            bottom: defaultCollectionBottomInset,
            right: 0
        )
        view.delegate = self
        return view
    }

    func makeDataSource() -> HomeDataSource {
        HomeDataSource(
            collectionView: collectionView,
            currentPageProvider: { [weak viewModel] in viewModel?.currentPage },
            pagesCountProvider: { [weak viewModel] in viewModel?.pages.count ?? 0 },
            currentIndexProvider: { [weak viewModel] in viewModel?.currentPageIndex ?? 0 }
        )
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSearchBarPosition()
    }
}

extension HomeViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didChangeText text: String) {
        viewModel.setSearchText(text)
    }

    func searchBarViewDidSubmit(_ searchBarView: SearchBarView) {
        view.endEditing(true)
    }
}
