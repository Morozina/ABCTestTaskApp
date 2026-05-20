# ABC Test App — SwiftUI

A small showcase iOS app implemented with SwiftUI. Demonstrates an image carousel, a list whose content is driven by the currently selected carousel page, a sticky search bar, and a statistics bottom sheet.

## Screenshots

| Main screen | Statistics sheet |
| :---: | :---: |
| <img width="320" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-20 at 11 50 40" src="https://github.com/user-attachments/assets/9a8c2787-4bac-47ea-84d2-6b7d85d1f548" /> | <img width="320" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-20 at 11 50 43" src="https://github.com/user-attachments/assets/fc62f02b-ab52-4972-b8a0-02b13a98248b" />|

## Features

- **Image carousel** — swipe horizontally to switch the page; the list below updates to reflect the items of the selected page. The carousel handles any number of pages.
- **Sticky search bar** — pinned section header inside a `List` (plain style). Uses iOS 26 `scrollEdgeEffectStyle(.soft, for: .top)` so the bar gets the system soft-edge effect when content scrolls beneath it.
- **Search** — filters the list of items by title and subtitle, case-insensitive, as the user types. Keyboard dismisses interactively when scrolling.
- **List with reuse** — items are rendered inside a `List` rather than a `LazyVStack`, so SwiftUI can recycle row views.
- **Floating action button** — opens a bottom sheet showing the item count of the currently visible page and the top-3 most frequent letters across all item titles of that page (for example `List 4 (7 items)` with `a = 15`, `n = 12`, `c = 11`). The title uses a `%lld items` plural variation from `Localizable.xcstrings`.
- **Empty state** for both the filtered list and the statistics sheet.
- **Dark Mode** via dynamic `UIColor` providers in the design system.
- **Dynamic Type** — text uses semantic styles (`.headline`, `.subheadline`, `.body`, `.callout`, `.title3`).
- **Accessibility** — explicit `accessibilityLabel` on the carousel page indicator, FAB, clear button, page image, and combined-children labels on list rows.
- **Localization** — strings live in `Localizable.xcstrings` (String Catalog) with plural variations for item counts.
- **Async data provider** — `PageDataProvider` protocol with a `LocalPageDataProvider` implementation. `HomeView.task` awaits pages on first appearance, so a network provider can be dropped in without touching the view layer.
- **No third-party dependencies.** Pure SwiftUI, code-only UI.

## Architecture

- MVVM with `@Observable` view model (Observation framework).
- `HomeViewModelInput` protocol decouples the view from the concrete view model.
- `HomeViewModel` is `@MainActor`. SwiftUI `View` types inherit MainActor isolation from the protocol.
- Pure data layer (`Page`, `ListItem`, `GradientColor`, `CharacterCount`, `PageStatistics`) — value types with no concurrency annotations.
- `CharacterStatisticsCalculator` is a `Sendable` struct conforming to `CharacterStatisticsCalculating`, injected into the view model.
- Design tokens centralized in `AppColor` (semantic + dynamic colors) and `AppMetrics`.
- Sticky search bar is a `Section` header inside `List(.plain)`; `scrollEdgeEffectStyle(.soft, for: .top)` provides the Liquid Glass scroll edge.
- The FAB is layered above the list with a `ZStack`. A trailing invisible row keeps the last item visible above the FAB without fighting SwiftUI's keyboard avoidance.
- One type per file, grouped by role (`Models`, `Services`, `ViewModels`, `Views`, `DesignSystem`, `Resources`).

## Project layout

```
APP-SwiftUI/
├── APP_SwiftUIApp.swift
├── Models/             — Page, ListItem, GradientColor, CharacterCount, PageStatistics
├── Services/           — PageDataProvider, LocalPageDataProvider, CharacterStatisticsCalculator
├── ViewModels/         — HomeViewModelInput, HomeViewModel (@Observable, @MainActor)
├── DesignSystem/       — AppColor, AppMetrics
├── Views/              — HomeView, CarouselView, PageIndicatorView, SearchBarView,
│                         ListItemRow, PageImageView, StatisticsSheetView,
│                         FloatingActionButton
└── Resources/          — Localizable.xcstrings

APP-SwiftUITests/
├── CharacterStatisticsCalculatorTests.swift
└── HomeViewModelTests.swift
```

## Tests

Unit tests live in the `APP-SwiftUITests` target. Run them from Xcode (`Cmd+U`) or via CLI:

```bash
xcodebuild -project APP-SwiftUI.xcodeproj \
  -scheme APP-SwiftUI \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  test
```

Coverage: `CharacterStatisticsCalculator` (spec example, tie-breaker, Unicode letters, case-insensitivity, limit, empty input) and `HomeViewModel` (initial state, async data loading, idempotency, error fallback, search filtering by title/subtitle/whitespace, page switching, statistics, sheet flag). Tests use a `StubPageDataProvider` to drive the view model without the local data set.

## Requirements

- iOS 26.0+
- Xcode 26+
- Swift 6

## Run

Open `APP-SwiftUI.xcodeproj` in Xcode and run on any iPhone simulator.
