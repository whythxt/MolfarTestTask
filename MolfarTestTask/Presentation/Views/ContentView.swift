import CoreData
import SwiftUI

struct ContentView: View {
    @State private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel = ContentViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.itemIDs, id: \.self) { id in
                        let item = viewModel.item(for: id)

                        NavigationLink(value: item?.category?.objectID) {
                            ItemRow(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.itemIDs.isEmpty {
                    ContentUnavailableView(
                        "No Items",
                        systemImage: "tray",
                        description: Text("Tap Generate to create random objects.")
                    )
                }
            }
            .navigationDestination(for: NSManagedObjectID.self) { categoryID in
                CategoryView(category: viewModel.category(for: categoryID))
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear", role: .destructive) {
                        Task { await viewModel.clear() }
                    }
                    .disabled(viewModel.isLoading || viewModel.itemIDs.isEmpty)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Generate") {
                        Task { await viewModel.generate() }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: errorBinding) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task { await viewModel.load() }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview {
    ContentView(
        viewModel: ContentViewModel(
            persistence: PersistenceController(inMemory: true)
        )
    )
}
