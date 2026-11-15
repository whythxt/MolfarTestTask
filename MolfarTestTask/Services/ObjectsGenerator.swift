import CoreData

nonisolated final class ObjectsGenerator {
    private let persistence: PersistenceController

    init(persistence: PersistenceController) {
        self.persistence = persistence
    }

    @concurrent
    func generate(count: Int = 100_000) async throws {
        let context = persistence.newBackgroundContext()
        var inserted = 0

        while inserted < count {
            try Task.checkCancellation()
            let chunk = min(5_000, count - inserted)

            try await context.perform {
                for _ in 0..<chunk {
                    let category = Category(context: context)
                    category.id = UUID()
                    category.title = Self.randomTitle()

                    for _ in 0..<Int.random(in: 1...3) {
                        let item = Item(context: context)
                        item.id = UUID()
                        item.title = Self.randomTitle()
                        item.price = Self.randomPrice()
                        item.category = category
                    }
                }

                try context.save()
                context.reset()
            }

            inserted += chunk
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
