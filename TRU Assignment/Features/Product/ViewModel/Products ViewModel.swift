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
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var hasMoreData = true
    
    // MARK: - Private Properties
    private let useCase: ProductsUseCaseProtocol
    private var currentPage = 0
    private let pageSize = 15
    
    // MARK: - Initialization
    init(useCase: ProductsUseCaseProtocol = ProductsUseCase()) {
        self.useCase = useCase
    }
    
    // MARK: - Public Methods
    func loadProducts() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        useCase.fetchProducts(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let products):
                    if self?.currentPage == 0 {
                        self?.products = products
                    } else {
                        self?.products.append(contentsOf: products)
                    }
                    
                    // Check if we have more data
                    self?.hasMoreData = products.count == self?.pageSize
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadMoreProducts() {
        guard !isLoadingMore && hasMoreData else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        useCase.fetchProducts(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingMore = false
                
                switch result {
                case .success(let products):
                    self?.products.append(contentsOf: products)
                    self?.hasMoreData = products.count == self?.pageSize
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    // Revert page number on failure
                    self?.currentPage -= 1
                }
            }
        }
    }
    
    func refreshProducts() {
        currentPage = 0
        hasMoreData = true
        products.removeAll()
        loadProducts()
    }
    
    func retry() {
        if currentPage == 0 {
            loadProducts()
        } else {
            loadMoreProducts()
        }
    }
    
    // MARK: - Helper Methods
    func shouldLoadMore(for product: Product) -> Bool {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return false }
        return index == products.count - 3 // Load more when 3 items away from end
    }
    
    func getCachedProducts() {
        products = useCase.getCachedProducts(page: currentPage)
    }
}
