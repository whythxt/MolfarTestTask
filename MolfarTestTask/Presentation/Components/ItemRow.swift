import SwiftUI

struct ItemRow: View {
    let item: Item?

    private var shortID: String {
        guard let id = item?.id.uuidString else { return "" }
        return String(id.prefix(8))
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item?.title ?? "—")
                    .font(.headline)

                Text(shortID)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(item?.price ?? 0, format: .currency(code: "USD"))
                .monospacedDigit()
        }
        .padding(.horizontal)
        .frame(height: 55)
        .overlay(alignment: .bottom) { Divider().padding(.leading) }
    }
}
