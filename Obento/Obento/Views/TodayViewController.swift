//
//  ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 18/2/22.
//

import UIKit

/// The view controller for the today tab
class TodayViewController: UIViewController, UIGestureRecognizerDelegate {
    // Feature recipe
    @IBOutlet weak var featuredRecipePuntuaction: UILabel!
    @IBOutlet weak var featuredRecipeTitle: UILabel!
    @IBOutlet weak var featuredRecipekcal: UILabel!
    @IBOutlet weak var featuredRecipeTime: UILabel!
    @IBOutlet weak var featuredRecipePrice: UILabel!
    @IBOutlet weak var featuredRecipeImage: UIImageView!
    @IBOutlet weak var featuredRecipeView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self
        
        featuredRecipeView.addGestureRecognizer(tapGesture)
        
        let exampleRecipe = Recipe(id: 0, userId: 0, name: "Sopa caliente de çorba", description: "", puntuaction: 4.7, kcal: 350, time: 40, price: 6.5, isLaunch: true, imagePath: "recipe_1", ingredients: [], steps: [])
        
        loadFeatureRecipe(exampleRecipe)
    }
    
    func loadFeatureRecipe(_ recipe: Recipe) {
        featuredRecipePuntuaction.text = String(recipe.puntuaction)
        featuredRecipeTitle.text = recipe.name
        featuredRecipekcal.text = String(recipe.kcal) + " kcal"
        featuredRecipeTime.text = String(recipe.time) + " min"
        featuredRecipePrice.text = String(recipe.price) + " €"
        featuredRecipeImage.image = UIImage(named: recipe.imagePath) // FIXME: Change this
    }
    
    @objc func clickView(_ sender: UIView) {
        let controller = (storyboard?.instantiateViewController(withIdentifier: "RecipeViewController"))!
        
        present(controller, animated: true, completion: nil)
    }
}

