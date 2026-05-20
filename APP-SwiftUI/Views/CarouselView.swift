import SwiftUI

struct CarouselView: View {
    let pages: [Page]
    @Binding var currentIndex: Int

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                PageImageView(page: page)
                    .padding(.horizontal, AppMetrics.horizontalPadding)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: AppMetrics.carouselHeight)
    }
}
