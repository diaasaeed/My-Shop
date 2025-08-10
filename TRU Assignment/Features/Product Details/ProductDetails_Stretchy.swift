//
//  ProductDetails + Stretchy.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 10/08/2025.
//

import Foundation
import UIKit

extension ProductDetailsViewController{
    
    // MARK: - Custom Stretchy Header View
    class StretchyTableHeaderView: UIView {
        
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupImageView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupImageView()
        }
        
        private func setupImageView() {
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        func scrollViewDidScroll(scrollView: UIScrollView) {
            let yOffset = scrollView.contentOffset.y
            
            if yOffset < 0 {
                // Stretching effect
                let scaleFactor = (-yOffset / frame.height) + 1
                imageView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                
                // Move the image up to keep it centered
                imageView.frame.origin.y = yOffset
            } else {
                imageView.transform = .identity
                imageView.frame.origin.y = 0
            }
        }
    }

}
