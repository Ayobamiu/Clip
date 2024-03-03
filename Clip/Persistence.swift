//
//  Persistence.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Clip")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            // Enable automatic migration
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Function to create a preview context with default data
    static func previewContext() -> NSManagedObjectContext {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // Add default data here
        for i in 0..<5 {
            let newItem = Item(context: context)
            newItem.timestamp = Date()
            newItem.textValue = "Random Value \(i)"
            newItem.isValueHidden = i % 2 == 0
            newItem.title = "Random Title \(i)"
        }
        
        return context
    }
}
