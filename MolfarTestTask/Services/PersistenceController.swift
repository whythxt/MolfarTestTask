import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    nonisolated let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MolfarTestTask")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    nonisolated func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        return context
    }
}
