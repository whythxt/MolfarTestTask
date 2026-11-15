import CoreData

@objc(Item)
nonisolated class Item: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var price: Double
    @NSManaged var category: Category?
}

extension Item {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Item> {
        NSFetchRequest<Item>(entityName: "Item")
    }
}
