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
        ingredientIcon.image = UIImage(named: ingredient.iconName)
        ingredientName.text = ingredient.name
        var quantityOptional: String = ""
        if ((ingredient.quantity ?? -1) != -1) {
            quantityOptional = "\(ingredient.quantity?.clean ?? "")"
        }
        quantity.text = "\(quantityOptional) \(ingredient.unit)"
    }
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
