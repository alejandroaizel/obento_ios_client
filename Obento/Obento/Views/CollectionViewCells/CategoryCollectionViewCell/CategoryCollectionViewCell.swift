//
//  CategoryCollectionViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CategoryCollectionViewCell.self)
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func setup(_ category: String) {
        categoryLabel.text = category
    }

}
