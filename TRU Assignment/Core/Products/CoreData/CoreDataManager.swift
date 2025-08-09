//
//  CoreDataManager.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TRU_Assignment")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data store failed to load: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Product Operations
    func saveProducts(_ products: [Product]) {
        // Check if ProductEntity exists
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context) else {
            print("ProductEntity not found in Core Data model. Please create it in Xcode.")
            return
        }
        
        // Clear existing products first
        clearAllProducts()
        
        for product in products {
            let _ = ProductEntity(context: context, product: product)
        }
        
        saveContext()
    }
    
    func fetchProducts(limit: Int = 15, offset: Int = 0) -> [Product] {
        // Check if ProductEntity exists
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context) else {
            print("ProductEntity not found in Core Data model. Please create it in Xcode.")
            return []
        }
        
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        request.fetchLimit = limit
        request.fetchOffset = offset
        
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toProduct() }
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    
    func getAllProducts() -> [Product] {
        // Check if ProductEntity exists
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context) else {
            print("ProductEntity not found in Core Data model. Please create it in Xcode.")
            return []
        }
        
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toProduct() }
        } catch {
            print("Error fetching all products: \(error)")
            return []
        }
    }
    
    func clearAllProducts() {
        // Check if ProductEntity exists
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context) else {
            print("ProductEntity not found in Core Data model. Please create it in Xcode.")
            return
        }
        
        let request: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error clearing products: \(error)")
        }
    }
    
    func getProductCount() -> Int {
        // Check if ProductEntity exists
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context) else {
            print("ProductEntity not found in Core Data model. Please create it in Xcode.")
            return 0
        }
        
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            return try context.count(for: request)
        } catch {
            print("Error getting product count: \(error)")
            return 0
        }
    }
    
    // MARK: - Entity Validation
    func isProductEntityAvailable() -> Bool {
        return NSEntityDescription.entity(forEntityName: "ProductEntity", in: context) != nil
    }
} 
