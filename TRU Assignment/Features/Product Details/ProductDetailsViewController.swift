//
//  ProductDetailsViewController.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 09/08/2025.
//

import Foundation
import UIKit

// MARK: - Alternative Implementation Using UITableView
class ProductDetailsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var product: Product?
    private let headerHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProductMainInfoCell", bundle: nil), forCellReuseIdentifier: "ProductMainInfoCell")
        tableView.register(UINib(nibName: "ProductDescriptionCell", bundle: nil), forCellReuseIdentifier: "ProductDescriptionCell")
        // Create stretchy header view
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight))
        headerView.imageView.contentMode = .scaleAspectFit
        
        // Load image if product is set
        if let product = product, let url = URL(string: product.image) {
            loadImage(from: url, into: headerView.imageView)
        }
        
        tableView.tableHeaderView = headerView
        
        // Configure content insets
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    func setProduct(_ product: Product) {
        self.product = product
        if isViewLoaded {
            tableView.reloadData()
            if let headerView = tableView.tableHeaderView as? StretchyTableHeaderView,
               let url = URL(string: product.image) {
                loadImage(from: url, into: headerView.imageView)
            }
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    imageView.image = image
                } else {
                    imageView.image = UIImage(systemName: "photo.fill")
                    imageView.tintColor = .systemGray4
                }
            }
        }.resume()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProductDetailsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // Title, Price, Rating, Description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        guard let product = product else { return cell }
        
        switch indexPath.row {
        case 0:
            let maincell = tableView.dequeueReusableCell(withIdentifier: "ProductMainInfoCell", for: indexPath) as! ProductMainInfoCell
            maincell.configure(product: product)
            return maincell
            
        case 1:
            
            let descCell = tableView.dequeueReusableCell(withIdentifier: "ProductDescriptionCell", for:indexPath) as! ProductDescriptionCell
            descCell.configure(product: product)
            
            return descCell

        default:
            break
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}
