//
//  UINavigationBar+Extensions.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import UIKit

extension UINavigationBar {
    
    func addGridListToggleButtons(target: Any?, gridAction: Selector, listAction: Selector, currentStyle: LayoutStyle) {
        // Create grid button
        let gridButton = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.2x2"),
            style: .plain,
            target: target,
            action: gridAction
        )
        gridButton.tintColor = currentStyle == .grid ? .systemBlue : .systemGray
        
        // Create list button
        let listButton = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: target,
            action: listAction
        )
        listButton.tintColor = currentStyle == .list ? .systemBlue : .systemGray
        
        // Add buttons to navigation bar
        self.topItem?.rightBarButtonItems = [listButton, gridButton]
    }
    
    func updateGridListButtonStates(currentStyle: LayoutStyle) {
        guard let rightBarButtonItems = self.topItem?.rightBarButtonItems,
              rightBarButtonItems.count >= 2 else { return }
        
        let gridButton = rightBarButtonItems[1] // Grid is second button
        let listButton = rightBarButtonItems[0] // List is first button
        
        if currentStyle == .grid {
            gridButton.tintColor = .systemBlue
            listButton.tintColor = .systemGray
        } else {
            gridButton.tintColor = .systemGray
            listButton.tintColor = .systemBlue
        }
    }
} 