//
//  ViewController.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 06/08/2025.
//

import UIKit
import SwiftUI
import Combine
import SkeletonView

enum LayoutStyle {
    case list
    case grid
}

class ProductListViewController: UIViewController {

    // MARK: - Properties
    var layoutStyle: LayoutStyle = .list
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    // MARK: - Combine
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - ViewModel
    let viewModel = ProductsViewModel()
    
    // MARK: - Layout Properties
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupNavigationBar()

        setupSkeletonView()
        showSkeletonAnimation()
        
        //Note:-  I added a 1-second timer here just to let you see the SkeletonView animation before the data loads
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.loadData()

        })
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Products"
        view.backgroundColor = .systemBackground
    }
    
    func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        // Register cells
        productCollectionView.register(UINib(nibName: "ProductGridCell", bundle: nil), forCellWithReuseIdentifier: "ProductGridCell")
        productCollectionView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellWithReuseIdentifier: "ProductListCell")
        
        // Set initial layout
        updateCollectionViewLayout()
    }
    
    
    // MARK: - Data Loading
    private func loadData() {
        viewModel.loadProducts()
        
        // Observe ViewModel changes
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.productCollectionView.reloadData()
                self?.hideSkeletonAnimation()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    // Show loading indicator
                    self?.showLoadingIndicator()
                } else {
                    // Hide loading indicator
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Helpers
    private func showLoadingIndicator() {
        // Implement loading indicator
//        showSkeletonAnimation()
        print("Loading...")
    }
    
    private func hideLoadingIndicator() {
        // Hide loading indicator
        self.hideSkeletonAnimation()
        print("Loading finished")
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.retry()
        })
        present(alert, animated: true)
    }

}

