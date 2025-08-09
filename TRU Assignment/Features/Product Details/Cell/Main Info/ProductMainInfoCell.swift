//
//  ProductMainInfoCell.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 10/08/2025.
//

import UIKit

class ProductMainInfoCell: UITableViewCell {
    
    @IBOutlet weak var producntTitle: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productCountReviews: UILabel!

    @IBOutlet weak var categoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        setupUI()
    }
    private func setupUI() {
        // categoryView - Only Corner Radius
        categoryView.layer.cornerRadius = 8
        categoryView.layer.masksToBounds = true
        categoryView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
             
        
        // Configure labels with proper spacing and constraints
        configureLabels()
    }
    
    
    private func configureLabels() {
        // Title label
        producntTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        producntTitle.numberOfLines = 2
        producntTitle.textColor = .label
        producntTitle.lineBreakMode = .byTruncatingTail
        
        // Category label
        productCategory.font = .systemFont(ofSize: 12, weight: .medium)
        productCategory.textColor = .secondaryLabel
        productCategory.numberOfLines = 1
        productCategory.lineBreakMode = .byTruncatingTail
        
        // Price label
        productPrice.font = .systemFont(ofSize: 18, weight: .bold)
        productPrice.textColor = .systemGreen
        productPrice.numberOfLines = 1
        
        // Rate label
        productRate.font = .systemFont(ofSize: 14, weight: .medium)
        productRate.textColor = .systemOrange
        productRate.numberOfLines = 1
        
        // Count reviews label
        productCountReviews.font = .systemFont(ofSize: 12, weight: .regular)
        productCountReviews.textColor = .tertiaryLabel
        productCountReviews.numberOfLines = 1
    }
    
    
    func configure(product: Product) {
        // Configure all labels with proper spacing
        producntTitle.text = product.title
        productCategory.text = product.category.capitalized
        productPrice.text = "$\(String(format: "%.2f", product.price))"
        productRate.text = "\(String(format: "%.1f", product.rating.rate))"
        productCountReviews.text = "(\(product.rating.count))"
    }

}
