//
//  CoreDataStack.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "UnitChatAuthenticator")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { container.viewContext }
    
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
