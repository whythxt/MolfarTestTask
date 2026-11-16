import CoreData

nonisolated final class ObjectsService {
    private let persistence: PersistenceController

    init(persistence: PersistenceController) {
        self.persistence = persistence
    }

    func generate(count: Int = 100_000) async throws {
        let context = persistence.newBackgroundContext()
        var inserted = 0

        while inserted < count {
            try Task.checkCancellation()
            let chunk = min(5_000, count - inserted)

            try await context.perform {
                var remaining = chunk

                while remaining > 0 {
                    let category = Category(context: context)
                    category.id = UUID()
                    category.title = Self.randomTitle()

                    let itemsInCategory = min(Int.random(in: 1...3), remaining)

                    for _ in 0..<itemsInCategory {
                        let item = Item(context: context)
                        item.id = UUID()
                        item.title = Self.randomTitle()
                        item.price = Self.randomPrice()
                        item.category = category
                    }

                    remaining -= itemsInCategory
                }

                try context.save()
                context.reset()
            }

            inserted += chunk
        }
    }

    func fetchItemIDs() async throws -> [NSManagedObjectID] {
        let context = persistence.newBackgroundContext()

        return try await context.perform {
            let request = NSFetchRequest<NSManagedObjectID>(entityName: "Item")
            request.resultType = .managedObjectIDResultType
            return try context.fetch(request)
        }
    }

    func deleteAll() async throws {
        let context = persistence.newBackgroundContext()

        try await context.perform {
            for entityName in ["Item", "Category"] {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                try context.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
            }
        }
    }

    // MARK: - Helpers

    private static let words = [
        "Sofa", "Armchair", "Table", "Chair", "Bed", "Wardrobe", "Bookshelf", "Desk",
        "Dresser", "Nightstand", "Lamp", "Mirror", "Carpet", "Bench", "Plug"
    ]

    private static func randomTitle() -> String {
        words.randomElement() ?? "Item"
    }

    private static func randomPrice() -> Double {
        (Double.random(in: 0...100) * 100).rounded() / 100
    }
}
