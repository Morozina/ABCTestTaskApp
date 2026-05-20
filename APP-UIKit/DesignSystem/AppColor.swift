import UIKit

enum AppColor {
    static let screenBackground = dynamic(
        light: UIColor(red: 0.91, green: 0.95, blue: 0.93, alpha: 1.0),
        dark: UIColor(red: 0.06, green: 0.10, blue: 0.08, alpha: 1.0)
    )

    static let cardBackground = dynamic(
        light: UIColor(red: 0.78, green: 0.89, blue: 0.83, alpha: 1.0),
        dark: UIColor(red: 0.12, green: 0.20, blue: 0.15, alpha: 1.0)
    )

    static let searchFieldBackground = dynamic(
        light: UIColor(red: 0.87, green: 0.90, blue: 0.88, alpha: 1.0),
        dark: UIColor(red: 0.18, green: 0.20, blue: 0.19, alpha: 1.0)
    )

    static let searchFieldPlaceholder = UIColor.secondaryLabel
    static let pageIndicatorInactive = UIColor.tertiaryLabel
    static let pageIndicatorActive = UIColor.systemBlue
    static let floatingActionButton = UIColor.systemBlue
    static let floatingActionButtonIcon = UIColor.white
    static let primaryText = UIColor.label
    static let secondaryText = UIColor.secondaryLabel

    private static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }
    }
}
