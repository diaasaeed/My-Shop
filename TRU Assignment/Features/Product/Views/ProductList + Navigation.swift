//
//  ProductList + Navigation.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 08/08/2025.
//

import Foundation

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
