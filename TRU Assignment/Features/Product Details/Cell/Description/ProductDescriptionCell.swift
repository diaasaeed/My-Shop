//
//  ProductDescriptionCell.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 10/08/2025.
//

import UIKit

class ProductDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    func configure(product: Product) {
        descriptionLable.text = product.description
    }
}
