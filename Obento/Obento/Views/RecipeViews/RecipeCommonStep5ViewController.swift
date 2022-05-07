//
//  RecipeCommonStep5ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class RecipeCommonStep5ViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var buttonCloseButton: UIButton!
    @IBOutlet weak var finalImage: UIImageView!
    
    var currentRecipe: Recipe!
    var recipe_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        finalStats()
        finalImage.image = UIImage(named: "new_recipe_final_illustration_" + String(Int.random(in: 1...4)))

        Task {
            self.recipe_id = await ObentoApi.postRecipe(recipe: self.currentRecipe)
        }
    }
    
    func finalStats() {
        var totalKcal: Float = 0
        var totalPrice: Float = 0.0
        
        for ing in currentRecipe.ingredients {
            totalKcal += ing.kcalories * ing.quantity!
            totalPrice += ing.unitaryPrice * ing.quantity!
        }
        
        currentRecipe.kcalories = totalKcal.rounded()
        currentRecipe.estimatedCost = round(totalPrice * 100) / 100.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bottonCloseButtonAction(_ sender: Any) {
        let controller = (
            storyboard?.instantiateViewController(
                withIdentifier: "RecipeViewController")
        ) as! RecipeViewController

        controller.recipeInformation = self.currentRecipe
        present(controller, animated: true, completion: nil)
    }
}
