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
        categoryView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        
        // Configure image view
        productImg.contentMode = .scaleAspectFit
        productImg.clipsToBounds = true
        productImg.layer.cornerRadius = 8
        productImg.backgroundColor = .systemGray6
        
        
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
        self.producntTitle.text = product.title
        self.productCategory.text = product.category
        self.productCountReviews.text = "(\(product.rating.count))"
        productPrice.text = "$\(String(format: "%.2f", product.price))"
        productRate.text = "\(String(format: "%.1f", product.rating.rate))"
        if let url = URL(string: product.image) {
            loadImage(from: url)
        }
    }

    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self?.productImg.image = image
                } else {
                    self?.productImg.image = UIImage(systemName: "photo")
                }
            }
        }.resume()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImg.image = nil
        producntTitle.text = nil
        productCategory.text = nil
        productPrice.text = nil
        productRate.text = nil
        productCountReviews.text = nil
    }
}
