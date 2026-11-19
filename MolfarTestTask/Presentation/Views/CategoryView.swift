import CoreData
import SwiftUI

struct CategoryView: View {
    let category: Category?

    private var items: [Item] {
        (category?.items ?? []).sorted {
            $0.title == $1.title ? $0.id.uuidString < $1.id.uuidString : $0.title < $1.title
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(items, id: \.objectID) { item in
                    ItemRow(item: item)
                }
            }
        }
        .navigationTitle(category?.title ?? "Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}
