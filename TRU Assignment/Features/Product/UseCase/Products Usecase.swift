//
//  Products Usecase.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation

protocol ProductsUseCaseProtocol {
    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void)
    func refreshProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func getCachedProducts(page: Int) -> [Product]
    func clearCache()
}

class ProductsUseCase: ProductsUseCaseProtocol {
    
    private let repository: ProductsRepositoryProtocol
    
    init(repository: ProductsRepositoryProtocol = ProductsRepository()) {
        self.repository = repository
    }
    
    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        
        repository.fetchProducts(limit: limit) { result in
            switch result {
            case .success(let products):
                print("UseCase: Successfully received \(products.count) products from repository")
                completion(.success(products))
                
            case .failure(let error):
                print("UseCase: Error fetching products: \(error.localizedDescription)")
                
                // Check if it's a timeout error
                if let apiError = error as? APIError {
                    switch apiError {
                    case .requestTimeOut:
                        print("Timeout error detected - network request took too long")
                    case .noInternet:
                        print(" No internet connection detected")
                    case .otherError(let message):
                        print(" Other error: \(message)")
                    default:
                        print(" API error: \(apiError.localizedDescription)")
                    }
                }
                
                completion(.failure(error))
            }
        }
    }
    
    func refreshProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        // Clear cache and fetch with default limit
        repository.clearCache()
        fetchProducts(limit: 7, completion: completion)
    }
    
    func getCachedProducts(page: Int) -> [Product] {
        let offset = page * 7
        return repository.getCachedProducts(limit: 7, offset: offset)
    }
    
    func clearCache() {
        repository.clearCache()
    }
}
