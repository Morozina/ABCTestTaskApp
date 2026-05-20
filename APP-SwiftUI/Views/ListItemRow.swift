import SwiftUI

struct ListItemRow: View {
    let item: ListItem
    let page: Page

    var body: some View {
        HStack(spacing: 14) {
            thumbnail

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(AppColor.primaryText)
                    .lineLimit(1)

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppColor.secondaryText)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .frame(minHeight: AppMetrics.listItemHeight, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: AppMetrics.cardCornerRadius, style: .continuous)
                .fill(AppColor.cardBackground)
        )
        .accessibilityElement(children: .combine)
    }

    private var thumbnail: some View {
        PageImageView(
            page: page,
            cornerRadius: AppMetrics.thumbnailCornerRadius,
            iconInset: 14,
            iconOverride: item.imageSymbol
        )
        .frame(width: AppMetrics.thumbnailSize, height: AppMetrics.thumbnailSize)
    }
}
