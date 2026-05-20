# ABC Test App — UIKit

A small showcase iOS app implemented with UIKit (no storyboards, code-only layout). Demonstrates an image carousel, a list whose content is driven by the currently selected carousel page, a sticky search bar, and a statistics bottom sheet.

## Screenshots

| Main screen | Statistics sheet |
| :---: | :---: |
| <img width="320" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-20 at 11 50 40" src="https://github.com/user-attachments/assets/9a8c2787-4bac-47ea-84d2-6b7d85d1f548" /> | <img width="320" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-20 at 11 50 43" src="https://github.com/user-attachments/assets/fc62f02b-ab52-4972-b8a0-02b13a98248b" />|

## Features

- **Image carousel** — swipe horizontally to switch the page; the list below updates to reflect the items of the selected page. The carousel handles any number of pages.
- **Sticky search bar** — a standalone `UIView` placed above the collection view; its top constraint is driven by `scrollViewDidScroll` so it floats under the page indicator and pins to the safe area when content scrolls past it. Keeping it outside the collection view means the text field never loses first responder on snapshot updates.
- **Search** — filters the list of items by title and subtitle, case-insensitive, as the user types. The keyboard dismisses on scroll, tap outside, and the keyboard's Search button.
- **Floating action button** — opens a bottom sheet showing the item count of the currently visible page and the top-3 most frequent letters across all item titles of that page (for example `List 4 (7 items)` with `a = 15`, `n = 12`, `c = 11`). The title uses a `%lld items` plural variation from `Localizable.xcstrings`.
- **Dark Mode** via dynamic `UIColor` providers in the design system; everything else uses semantic colors (`.label`, `.systemBlue`, `.tertiaryLabel`, etc.).
- **Dynamic Type** — labels use `preferredFont(forTextStyle:)` with `adjustsFontForContentSizeCategory = true`, including the monospaced statistics rows.
- **Accessibility** — explicit `accessibilityLabel` on the FAB, page image, list cells (combined title + subtitle), and indicator.
- **Localization** — strings live in `Localizable.xcstrings` (String Catalog) with plural variations for item counts. Code uses `String(localized:)` and a tiny `"key".localized` helper.
- **Async data provider** — `PageDataProvider` protocol with a `LocalPageDataProvider` implementation. The view model awaits pages on first appearance, so a network provider can be dropped in without touching the view layer.
- **No third-party dependencies.** Pure UIKit, no storyboards, layout in code with Auto Layout.

## Architecture

- MVVM with `@Observable` view model. `HomeViewController` subscribes via `withObservationTracking` and re-registers on each change.
- `HomeViewModelInput` protocol decouples the controller from the concrete view model.
- No storyboards: `SceneDelegate` creates the root view controller programmatically.
- Single `UICollectionView` driven by `UICollectionViewCompositionalLayout` with three sections (carousel, page indicator, list). Layout factory (`HomeLayoutFactory`) and diffable data source builder (`HomeDataSource`) are extracted from the controller.
- Carousel uses an orthogonal `.paging` group; current page index is tracked via `visibleItemsInvalidationHandler` and dispatched async to avoid layout-during-layout.
- Search bar lives **outside** the collection view as a `SearchBarView`. Its top anchor constant is recomputed in `scrollViewDidScroll` to match the items section start, clamped to the safe area top. This sidesteps the well-known first-responder loss when applying snapshots with pinned supplementary headers.
- `UICollectionViewDiffableDataSource` over `Sendable` `HomeSection` / `HomeCellItem` identifiers.
- `CharacterStatisticsCalculator` is a `Sendable` struct conforming to `CharacterStatisticsCalculating`, injected into the view model.
- Bottom sheet implemented with `UISheetPresentationController` and `.medium()` detent.
- Design tokens centralized in `AppColor` (semantic + dynamic colors) and `AppMetrics`.
- Keyboard handling: `keyboardWillChangeFrameNotification` + `keyboardWillHideNotification` animate `collectionView.contentInset.bottom`. A tap gesture on the collection view also dismisses.
- Concurrency policy: `HomeViewModel` is `@MainActor`. `UIViewController` / `UIView` subclasses inherit MainActor isolation from the SDK. Models are plain value types.
- One type per file, grouped by role.

## Project layout

```
APP-UIKit/
├── AppDelegate.swift
├── SceneDelegate.swift           — code-only window setup
├── Extensions/                   — String+Localized
├── Models/                       — Page, ListItem, GradientColor, CharacterCount, PageStatistics
├── Services/                     — PageDataProvider, LocalPageDataProvider, CharacterStatisticsCalculator
├── ViewModels/                   — HomeViewModelInput, HomeViewModel (@Observable, @MainActor)
├── DesignSystem/                 — AppColor, AppMetrics
├── Home/                         — HomeSection, HomeCellItem, HomeLayoutFactory, HomeDataSource
├── ViewControllers/              — HomeViewController, StatisticsSheetViewController
├── Views/                        — CarouselCell, IndicatorCell, ListItemCell,
│                                   SearchBarView, PageImageView, PageIndicatorView,
│                                   FloatingActionButton
└── Resources/                    — Localizable.xcstrings

APP-UIKitTests/
├── CharacterStatisticsCalculatorTests.swift
└── HomeViewModelTests.swift
```

## Tests

Unit tests live in the `APP-UIKitTests` target. Run them from Xcode (`Cmd+U`) or via CLI:

```bash
xcodebuild -project APP-UIKit.xcodeproj \
  -scheme APP-UIKit \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  test
```

Coverage: `CharacterStatisticsCalculator` (spec example, tie-breaker, Unicode letters, case-insensitivity, limit, empty input) and `HomeViewModel` (initial state, async data loading, idempotency, error fallback, search filtering, page switching, statistics, out-of-bounds guard). Tests use a `StubPageDataProvider` to drive the view model without the local data set.

## Requirements

- iOS 26.0+
- Xcode 26+
- Swift 6

## Run

Open `APP-UIKit.xcodeproj` in Xcode and run on any iPhone simulator.
