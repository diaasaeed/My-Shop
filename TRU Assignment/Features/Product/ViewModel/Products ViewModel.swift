//
//  Products ViewModel.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation
import Combine

@MainActor
class ProductsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let useCase: ProductsUseCaseProtocol
    private var currentLimit = 7
    private var hasReachedEnd = false
    private var retryCount = 0
    private let maxRetries = 2
    
    // MARK: - Initialization
    init(useCase: ProductsUseCaseProtocol = ProductsUseCase()) {
        self.useCase = useCase
        print("ProductsViewModel initialized - currentLimit: \(currentLimit)")
    }
    
    // MARK: - Public Methods
    func loadProducts() {
        guard !isLoading else { return }
        
        print("🚀 Loading products with limit: \(currentLimit), retry: \(retryCount)")
        isLoading = true
        errorMessage = nil
        
        useCase.fetchProducts(limit: currentLimit) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let products):
                    print("Received \(products.count) products")
                    self?.products = products
                    self?.retryCount = 0  // Reset retry count on success
                    
                    // Check if we got fewer products than requested (end of data)
                    if products.count < self?.currentLimit ?? 7 {
                        self?.hasReachedEnd = true
                        print("Reached end of data - got \(products.count) products, limit was \(self?.currentLimit ?? 7)")
                    }
                    
                case .failure(let error):
                    print("❌ Failed to load products: \(error.localizedDescription)")
                    
                    // Check if we should retry (only for initial load and network issues)
                    if let self = self, 
                       self.currentLimit == 7 && // Only retry initial load
                       self.retryCount < self.maxRetries,
                       let apiError = error as? APIError {
                        
                        switch apiError {
                        case .requestTimeOut, .noInternet, .otherError:
                            self.retryCount += 1
                            print("Retrying load (\(self.retryCount)/\(self.maxRetries)) after network error...")
                            
                            // Retry after a short delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.loadProducts()
                            }
                            return
                        default:
                            break
                        }
                    }
                    
                    // No retry or retry exhausted
                    self?.errorMessage = error.localizedDescription
                    self?.retryCount = 0
                }
            }
        }
    }
    
    func loadMoreProducts() {
        guard !isLoading && !hasReachedEnd else { 
            print("LoadMore blocked: isLoading=\(isLoading), hasReachedEnd=\(hasReachedEnd)")
            return
        }
        
        // Increase limit by 7
        currentLimit += 7
        // Reload all data with new limit
        loadProducts()
    }
    
    func refreshProducts() {
        currentLimit = 7
        hasReachedEnd = false
        retryCount = 0  // Reset retry count on refresh
        products.removeAll()
        loadProducts()
    }
    
    func retry() {
        retryCount = 0  // Reset retry count on manual retry
        loadProducts()
    }
    
    // MARK: - Helper Methods
    func shouldLoadMore(for product: Product) -> Bool {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return false }
        // Load more when 3 items away from end
        let shouldLoad = index >= products.count - 3
        return shouldLoad
    }
    
    func getCachedProducts() {
        products = useCase.getCachedProducts(page: 0)
    }
}
