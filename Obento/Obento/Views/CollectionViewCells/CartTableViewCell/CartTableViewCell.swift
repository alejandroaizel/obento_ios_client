//
//  CartTableViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 13/3/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    static let identifier = String(describing: CartTableViewCell.self)
    
    @IBOutlet weak var ingredientIcon: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var units: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    func setup(_ ingredient: Ingredient) {
        ingredientIcon.image = UIImage(named: ingredient.iconName)
        ingredientName.text = ingredient.name
        units.text = "x " + String(ingredient.quantity ?? -1) + ingredient.unit
        let price = round(100 * ((ingredient.quantity ?? -1) * ingredient.unitaryPrice)) / 100
        totalPrice.text = "\(price) €"
    }
}
