import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.searchFieldPlaceholder)

            TextField("", text: $text, prompt: Text("Search").foregroundStyle(AppColor.searchFieldPlaceholder))
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundStyle(AppColor.primaryText)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppColor.searchFieldPlaceholder)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Clear search"))
            }
        }
        .padding(.horizontal, 12)
        .frame(height: AppMetrics.searchFieldHeight)
        .background(
            RoundedRectangle(cornerRadius: AppMetrics.searchFieldCornerRadius, style: .continuous)
                .fill(AppColor.searchFieldBackground)
        )
    }
}
