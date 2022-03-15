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
        ingredientIcon.image = UIImage(named: ingredient.iconPath)
        ingredientName.text = ingredient.name
        units.text = "x " + String(ingredient.quantity ?? -1) + ingredient.unit
        totalPrice.text = String(Double((ingredient.quantity ?? -1)) * ingredient.unitaryPrice) + " €"
    }
}
