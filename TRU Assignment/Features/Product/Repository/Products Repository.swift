//
//  Products Repository.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation

protocol ProductsRepositoryProtocol {
    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void)
    func getCachedProducts(limit: Int, offset: Int) -> [Product]
    func saveProductsToCache(_ products: [Product])
    func clearCache()
}

class ProductsRepository: ProductsRepositoryProtocol {
    
    private let productsRequest: ProductsRequest
    private let coreDataManager: CoreDataManager
    private let reachabilityManager: NetworkReachabilityManager
    
    // Temporary in-memory cache until Core Data is set up
    private var inMemoryCache: [Product] = []
    
    init(productsRequest: ProductsRequest = ProductsRequest(),
         coreDataManager: CoreDataManager = CoreDataManager.shared,
         reachabilityManager: NetworkReachabilityManager = NetworkReachabilityManager.shared) {
        self.productsRequest = productsRequest
        self.coreDataManager = coreDataManager
        self.reachabilityManager = reachabilityManager
    }
    
    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        // Check if we have internet connection
        if reachabilityManager.isConnected {
            // Fetch from network using ProductsRequest
            productsRequest.fetchProducts(limit: limit) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let products):
                        // Save to cache (Core Data or in-memory)
                        self?.saveProductsToCache(products)
                        completion(.success(products))
                    case .failure(let error):
                        // If network fails, try to get from cache
                        let cachedProducts = self?.getCachedProducts(limit: limit, offset: 0) ?? []
                        if !cachedProducts.isEmpty {
                            completion(.success(cachedProducts))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
            }
        } else {
            // No internet connection, get from cache
            let cachedProducts = getCachedProducts(limit: limit, offset: 0)
            if !cachedProducts.isEmpty {
                completion(.success(cachedProducts))
            } else {
                completion(.failure(APIError.noInternet))
            }
        }
    }
    
    func getCachedProducts(limit: Int, offset: Int) -> [Product] {
        // Try Core Data first, fallback to in-memory cache
        if coreDataManager.isProductEntityAvailable() {
            return coreDataManager.fetchProducts(limit: limit, offset: offset)
        } else {
            // Use in-memory cache as fallback
            let endIndex = min(offset + limit, inMemoryCache.count)
            let startIndex = min(offset, inMemoryCache.count)
            if startIndex < endIndex {
                return Array(inMemoryCache[startIndex..<endIndex])
            }
            return []
        }
    }
    
    func saveProductsToCache(_ products: [Product]) {
        // Try Core Data first, fallback to in-memory cache
        if coreDataManager.isProductEntityAvailable() {
            coreDataManager.saveProducts(products)
        } else {
            // Use in-memory cache as fallback
            inMemoryCache = products
        }
    }
    
    func clearCache() {
        // Try Core Data first, fallback to in-memory cache
        if coreDataManager.isProductEntityAvailable() {
            coreDataManager.clearAllProducts()
        } else {
            // Clear in-memory cache
            inMemoryCache.removeAll()
        }
    }
}
