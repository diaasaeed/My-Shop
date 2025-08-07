//
//  ViewController.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 06/08/2025.
//

import UIKit
import SwiftUI

enum LayoutStyle {
    case list
    case grid
}


class ProductListViewController: UIViewController {

    var layoutStyle: LayoutStyle = .list
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
}

