import SwiftUI

struct PageImageView: View {
    let page: Page
    var cornerRadius: CGFloat = AppMetrics.carouselCornerRadius
    var iconInset: CGFloat = 40
    var iconOverride: String? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [page.gradientStart.color, page.gradientEnd.color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: iconOverride ?? page.imageSymbol)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white.opacity(0.35))
                .padding(iconInset)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityElement()
        .accessibilityLabel(Text(page.title))
    }
}
