//
//  Products Usecase.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation

protocol ProductsUseCaseProtocol {
    func fetchProducts(page: Int, completion: @escaping (Result<[Product], Error>) -> Void)
    func refreshProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func getCachedProducts(page: Int) -> [Product]
    func clearCache()
}

class ProductsUseCase: ProductsUseCaseProtocol {
    
    private let repository: ProductsRepositoryProtocol
    private let pageSize = 7
    private var allFetchedProducts: [Product] = []
    private var currentPage = 0
    
    init(repository: ProductsRepositoryProtocol = ProductsRepository()) {
        self.repository = repository
    }
    
    func fetchProducts(page: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        // If we're requesting a page we haven't fetched yet, fetch it
        if page >= currentPage {
            // Fetch the next batch of products
            repository.fetchProducts(limit: pageSize) { [weak self] result in
                switch result {
                case .success(let newProducts):
                    // Add new products to our accumulated list
                    self?.allFetchedProducts.append(contentsOf: newProducts)
                    self?.currentPage += 1
                    
                    // Return products for the requested page
                    let startIndex = page * (self?.pageSize ?? 0)
                    let endIndex = min(startIndex + (self?.pageSize ?? 7), self?.allFetchedProducts.count ?? 0)
                    
                    if startIndex < (self?.allFetchedProducts.count ?? 0) {
                        let pageProducts = Array(self?.allFetchedProducts[startIndex..<endIndex] ?? [])
                        completion(.success(pageProducts))
                    } else {
                        completion(.success([]))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // Return products from already fetched data
            let startIndex = page * pageSize
            let endIndex = min(startIndex + pageSize, allFetchedProducts.count)
            
            if startIndex < allFetchedProducts.count {
                let pageProducts = Array(allFetchedProducts[startIndex..<endIndex])
                completion(.success(pageProducts))
            } else {
                completion(.success([]))
            }
        }
    }
    
    func refreshProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        // Clear cache and reset pagination
        repository.clearCache()
        allFetchedProducts.removeAll()
        currentPage = 0
        fetchProducts(page: 0, completion: completion)
    }
    
    func getCachedProducts(page: Int) -> [Product] {
        let offset = page * pageSize
        return repository.getCachedProducts(limit: pageSize, offset: offset)
    }
    
    func clearCache() {
        repository.clearCache()
        allFetchedProducts.removeAll()
        currentPage = 0
    }
}
