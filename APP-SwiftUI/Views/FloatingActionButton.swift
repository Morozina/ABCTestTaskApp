import SwiftUI

struct FloatingActionButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(AppColor.floatingActionButtonIcon)
                .frame(width: AppMetrics.floatingActionButtonSize, height: AppMetrics.floatingActionButtonSize)
                .background(
                    Circle().fill(AppColor.floatingActionButton)
                )
                .shadow(color: Color.black.opacity(0.20), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Show statistics"))
    }
}
