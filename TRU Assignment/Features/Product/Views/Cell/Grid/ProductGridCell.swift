//
//  ProductGridCell.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import UIKit

class ProductGridCell: UICollectionViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var producntTitle: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productCountReviews: UILabel!
    @IBOutlet weak var producntView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        // producntView - Shadow + Corner Radius
        producntView.layer.cornerRadius = 12
        producntView.layer.shadowColor = UIColor.black.cgColor
        producntView.layer.shadowOpacity = 0.1
        producntView.layer.shadowOffset = CGSize(width: 0, height: 2)
        producntView.layer.shadowRadius = 6
        producntView.layer.masksToBounds = false
        producntView.backgroundColor = .white  // or your cell background color

        // categoryView - Only Corner Radius
        categoryView.layer.cornerRadius = 8
        categoryView.layer.masksToBounds = true
    }
    
    
    func setProductData(product: Product) {
        self.producntTitle.text = product.title
        self.productCategory.text = product.category
        self.productPrice.text = "\(product.price)"
        self.productRate.text = "\(product.rating.rate)"
        self.productCountReviews.text = "\(product.rating.count)"
    }

}
