import UIKit

struct GradientColor: Hashable, Sendable {
    let red: Double
    let green: Double
    let blue: Double

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
