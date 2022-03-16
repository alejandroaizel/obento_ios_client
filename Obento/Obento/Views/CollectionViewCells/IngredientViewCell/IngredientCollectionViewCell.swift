//
//  IngredientCollectionViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 15/3/22.
//

import UIKit

class IngredientCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: IngredientCollectionViewCell.self)
    
    @IBOutlet weak var ingredientIcon: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    func setup(_ ingredient: Ingredient) {
        ingredientIcon.image = UIImage(named: ingredient.iconPath)
        ingredientName.text = ingredient.name
        quantity.text = String(ingredient.quantity ?? -1) + " " + ingredient.unit
    }
}
