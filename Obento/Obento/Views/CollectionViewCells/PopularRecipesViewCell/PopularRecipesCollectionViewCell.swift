//
//  PopularRecipesCollectionViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 12/3/22.
//

import UIKit

class PopularRecipesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: PopularRecipesCollectionViewCell.self)
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipePuntuaction: UILabel!
    
    func setup(_ recipe: Recipe) {
        recipeImage.image = UIImage(named: "recipe_1") // TODO: Cambiar a la imagen del path de la receta
        recipeTitle.text = recipe.name
        recipePuntuaction.text = "5.0" // TODO: score String(recipe.puntuaction)
    }
}
