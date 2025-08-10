//
//  ProductList + CollectionView.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 08/08/2025.
//

import Foundation
import UIKit
import SkeletonView

extension ProductListViewController{
    // MARK: - Layout Methods
    func updateCollectionViewLayout() {
        let layout = createLayout(for: layoutStyle)
        // Use animated transition to new layout
        productCollectionView.setCollectionViewLayout(layout, animated: false) { _ in
            // Force reload after layout change to ensure correct cell types
            self.productCollectionView.reloadData()
        }
    }
    
    func createLayout(for style: LayoutStyle) -> UICollectionViewLayout {
        switch style {
        case .grid:
            return createGridLayout()
        case .list:
            return createListLayout()
        }
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let columns = isIPad ? 4 : 2
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(290) // Increased height for better text spacing
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let columns = isIPad ? 2 : 1
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .absolute(isIPad ? 180 : 160) // Increased height for better text spacing
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12) // Increased insets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(isIPad ? 180 : 160)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16) // Increased spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
}


// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = viewModel.products[indexPath.item]
        
        switch layoutStyle {
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGridCell", for: indexPath) as! ProductGridCell
                cell.configure(product: product)
            return cell
            
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
            cell.configure(product: product)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.item]
        // Handle product selection
        // In your presenting view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        detailsVC.setProduct(product)
        navigationController?.pushViewController(detailsVC, animated: true)
        print("Selected product: \(product.title)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.products.count else { return }
        let product = viewModel.products[indexPath.item]
        if viewModel.shouldLoadMore(for: product) {
            viewModel.loadMoreProducts()
        } else {
            print("Not triggering loadMore - shouldLoadMore returned false")
        }
    }
}

