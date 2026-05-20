import SwiftUI

struct StatisticsSheetView: View {
    let statistics: PageStatistics

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(titleText)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppColor.primaryText)
                .padding(.top, 8)

            if statistics.topCharacters.isEmpty {
                Text("No characters to show")
                    .font(.body)
                    .foregroundStyle(AppColor.secondaryText)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(statistics.topCharacters) { entry in
                        HStack {
                            Text(String(entry.character))
                                .font(.system(.body, design: .monospaced).weight(.medium))
                                .foregroundStyle(AppColor.primaryText)
                            Text("=")
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(AppColor.secondaryText)
                            Text("\(entry.count)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(AppColor.primaryText)
                            Spacer()
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationBackground(.thinMaterial)
    }

    private var titleText: String {
        let itemsText = String.localizedStringWithFormat(
            String(localized: "%lld items"),
            statistics.itemCount
        )
        return String.localizedStringWithFormat(
            String(localized: "List %lld (%@)"),
            statistics.pageNumber,
            itemsText
        )
    }
}
