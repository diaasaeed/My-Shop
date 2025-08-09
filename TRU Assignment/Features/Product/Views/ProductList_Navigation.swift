//
//  ProductList + Navigation.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 08/08/2025.
//

import Foundation
import SkeletonView
extension ProductListViewController {
    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.addGridListToggleButtons(
            target: self,
            gridAction: #selector(gridButtonTapped),
            listAction: #selector(listButtonTapped),
            currentStyle: layoutStyle
        )
    }
    
    
    // MARK: - Action Methods
    @objc func gridButtonTapped() {
        layoutStyle = .grid
        updateCollectionViewLayout()
        navigationController?.navigationBar.updateGridListButtonStates(currentStyle: layoutStyle)
        productCollectionView.reloadData()
    }
    
    @objc func listButtonTapped() {
        layoutStyle = .list
        updateCollectionViewLayout()
        navigationController?.navigationBar.updateGridListButtonStates(currentStyle: layoutStyle)
        productCollectionView.reloadData()
    }
    
}



// MARK: - SkeletonView Extension
extension ProductListViewController {
    
    // MARK: - Setup Skeleton
    func setupSkeletonView() {
        // Make collection view skeletonable
        productCollectionView.isSkeletonable = true
    }
    
    // MARK: - Show Skeleton Animation
    func showSkeletonAnimation() {
        print("🦴 Showing skeleton animation for backend response...")
        
        // Create sliding animation
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        
        // Create gradient for skeleton
        let gradient = SkeletonGradient(
            baseColor: .systemGray5,
            secondaryColor: .systemGray4
        )
        
        // Show animated gradient skeleton
        productCollectionView.showAnimatedGradientSkeleton(
            usingGradient: gradient,
            animation: animation,
            transition: .crossDissolve(0.3)
        )
    }
    
    // MARK: - Hide Skeleton Animation
    func hideSkeletonAnimation() {
        print("🦴 Hiding skeleton animation after backend response...")
        
        productCollectionView.hideSkeleton(
            reloadDataAfter: true,
            transition: .crossDissolve(0.3)
        )
    }
    
    // MARK: - Show Skeleton for Layout Switch
    func showSkeletonForLayoutTransition() {
        print("🦴 Showing skeleton for layout transition...")
        
        // Create faster animation for layout switch
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        
        let gradient = SkeletonGradient(
            baseColor: .systemGray6,
            secondaryColor: .systemGray4
        )
        
        productCollectionView.showAnimatedGradientSkeleton(
            usingGradient: gradient,
            animation: animation,
            transition: .crossDissolve(0.2)
        )
    }
}

// MARK: - SkeletonCollectionViewDataSource
extension ProductListViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // Return appropriate cell identifier based on current layout
        switch layoutStyle {
        case .grid:
            return "ProductGridCell"
        case .list:
            return "ProductListCell"
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Show different number of skeleton items based on layout
        switch layoutStyle {
        case .grid:
            return isIPad ? 10 : 8  // More items for grid layout
        case .list:
            return isIPad ? 8 : 6  // Fewer items for list layout
        }
    }
}
