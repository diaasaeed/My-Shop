//
//  ProductEntity+CoreDataProperties.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation
import CoreData

extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var category: String?
    @NSManaged public var image: String?
    @NSManaged public var ratingRate: Double
    @NSManaged public var ratingCount: Int64
    @NSManaged public var createdAt: Date?

} 