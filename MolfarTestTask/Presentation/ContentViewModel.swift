import CoreData

@Observable
final class ContentViewModel {
    private(set) var itemIDs: [NSManagedObjectID] = []
    private(set) var isLoading = false

    var errorMessage: String?

    private let persistence: PersistenceController
    private let objectsService: ObjectsService

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
        self.objectsService = ObjectsService(persistence: persistence)
    }

    func load() async {
        await run {
            itemIDs = try await objectsService.fetchItemIDs()
        }
    }

    func generate() async {
        await run {
            try await objectsService.generate()
            itemIDs = try await objectsService.fetchItemIDs()
        }
    }

    func clear() async {
        await run {
            try await objectsService.deleteAll()
            itemIDs = []
        }
    }

    func item(for id: NSManagedObjectID) -> Item? {
        try? persistence.viewContext.existingObject(with: id) as? Item
    }

    // MARK: - Helpers

    private func run(_ work: () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await work()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
