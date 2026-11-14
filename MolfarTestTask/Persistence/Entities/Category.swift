import CoreData

@objc(Category)
nonisolated class Category: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var createdAt: Date
    @NSManaged var items: Set<Item>
}

extension Category {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Category> {
        NSFetchRequest<Category>(entityName: "Category")
    }
}
