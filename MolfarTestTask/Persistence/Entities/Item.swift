import CoreData

@objc(Item)
nonisolated class Item: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var value: Int64
    @NSManaged var createdAt: Date
    @NSManaged var category: Category?
}

extension Item {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Item> {
        NSFetchRequest<Item>(entityName: "Item")
    }
}
