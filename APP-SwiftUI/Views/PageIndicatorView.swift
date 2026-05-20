import SwiftUI

struct PageIndicatorView: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: AppMetrics.pageIndicatorSpacing) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? AppColor.pageIndicatorActive : AppColor.pageIndicatorInactive)
                    .frame(width: AppMetrics.pageIndicatorDotSize, height: AppMetrics.pageIndicatorDotSize)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
        .accessibilityElement()
        .accessibilityLabel(Text("Page \(currentIndex + 1) of \(count)"))
    }
}
