//
//  Product Request.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation

class ProductsRequest {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = moyaProvider) {
        self.networkClient = networkClient
    }
    
    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        let api = ProductsAPI.getProducts(limit: limit)
        
        networkClient.performRequest(api: api, decodeTo: [Product].self) { result in
            DispatchQueue.main.async {
                // Convert APIError to Error
                switch result {
                case .success(let products):
                    completion(.success(products))
                case .failure(let apiError):
                    completion(.failure(apiError as Error))
                }
            }
        }
    }
}
