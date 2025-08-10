import Foundation
@testable import TRU_Assignment

final class MockProductsRepository: ProductsRepositoryProtocol {
    // Configuration
    var fetchResultQueue: [Result<[Product], Error>] = []
    var cachedProductsStore: [Product] = []
    
    // Tracking
    private(set) var lastFetchLimit: Int?
    private(set) var clearCacheCallCount: Int = 0
    
    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        lastFetchLimit = limit
        let result = fetchResultQueue.isEmpty ? .success([]) : fetchResultQueue.removeFirst()
        DispatchQueue.main.async { completion(result) }
    }
    
    func getCachedProducts(limit: Int, offset: Int) -> [Product] {
        let start = min(offset, cachedProductsStore.count)
        let end = min(offset + limit, cachedProductsStore.count)
        if start < end { return Array(cachedProductsStore[start..<end]) }
        return []
    }
    
    func saveProductsToCache(_ products: [Product]) {
        cachedProductsStore = products
    }
    
    func clearCache() {
        clearCacheCallCount += 1
        cachedProductsStore.removeAll()
    }
}

// MARK: - Test helpers
extension Product {
    static func sample(id: Int = 1, title: String = "Item", price: Double = 9.99) -> Product {
        Product(
            id: id,
            title: "\(title) #\(id)",
            price: price,
            description: "desc #\(id)",
            category: "cat",
            image: "https://example.com/\(id).png",
            rating: Rating(rate: 4.5, count: 10)
        )
    }
}

extension Array where Element == Product {
    static func samples(count: Int) -> [Product] {
        (0..<count).map { .sample(id: $0 + 1) }
    }
}