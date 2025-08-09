//
//  ProductEntity+CoreDataClass.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation
import CoreData

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {
    
    // MARK: - Convenience Initializer
    convenience init(context: NSManagedObjectContext, product: Product) {
        self.init(context: context)
        self.id = Int64(product.id)
        self.title = product.title
        self.price = product.price
        self.productDescription = product.description
        self.category = product.category
        self.image = product.image
        self.ratingRate = product.rating.rate
        self.ratingCount = Int64(product.rating.count)
        self.createdAt = Date()
    }
    
    // MARK: - Convert to Product Model
    func toProduct() -> Product {
        return Product(
            id: Int(self.id),
            title: self.title ?? "",
            price: self.price,
            description: self.productDescription ?? "",
            category: self.category ?? "",
            image: self.image ?? "",
            rating: Rating(
                rate: self.ratingRate,
                count: Int(self.ratingCount)
            )
        )
    }
} 
