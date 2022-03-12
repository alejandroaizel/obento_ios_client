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
    
    // Categories
    @IBOutlet weak var allCategory: UIView!
    @IBOutlet weak var riceCategory: UIView!
    @IBOutlet weak var pastaCategory: UIView!
    @IBOutlet weak var vegetablesCategory: UIView!
    @IBOutlet weak var meatCategory: UIView!
    @IBOutlet weak var fishCategory: UIView!
    
    
    var categories: [UIView] = []
    var currentSelectedCategory = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = [allCategory, riceCategory, pastaCategory, vegetablesCategory, meatCategory, fishCategory]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self
        
        featuredRecipeView.addGestureRecognizer(tapGesture)
        
        let exampleRecipe = Recipe(id: 0, userId: 0, name: "Sopa caliente de çorba", description: "", puntuaction: 4.7, kcal: 350, time: 40, price: 6.5, isLaunch: true, imagePath: "recipe_1", ingredients: [], steps: [])
        
        loadFeatureRecipe(exampleRecipe)
        loadCategories()
    }
    
    func loadFeatureRecipe(_ recipe: Recipe) {
        featuredRecipePuntuaction.text = String(recipe.puntuaction)
        featuredRecipeTitle.text = recipe.name
        featuredRecipekcal.text = String(recipe.kcal) + " kcal"
        featuredRecipeTime.text = String(recipe.time) + " min"
        featuredRecipePrice.text = String(recipe.price) + " €"
        featuredRecipeImage.image = UIImage(named: recipe.imagePath) // FIXME: Change this
    }
    
    func loadCategories() {
        for i in 0..<categories.count {
            categories[i].tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickCategory(_:)))
            tapGesture.delegate = self
            
            categories[i].addGestureRecognizer(tapGesture)
        }
    }
    
    func changeCategory(_ selection: Int) {
        for i in 0..<categories.count {
            categories[i].backgroundColor = .black
            
        }
    }
    
    @objc func clickView(_ sender: UIView) {
        let controller = (storyboard?.instantiateViewController(withIdentifier: "RecipeViewController"))!
        
        present(controller, animated: true, completion: nil)
    }
    
    @objc func clickCategory(_ sender: UITapGestureRecognizer) {
        let senderView = sender.view!
        let viewTag = senderView.tag
        
        categories[viewTag].backgroundColor = UIColor(named: "ObentoGreen")
        let viewLabel: UILabel = categories[viewTag].subviews[0] as! UILabel
        viewLabel.textColor = .white
        
        categories[currentSelectedCategory].backgroundColor = UIColor(named: "SecondaryColor")
        let currentViewLabel = categories[currentSelectedCategory].subviews[0] as! UILabel
        currentViewLabel.textColor = UIColor(named: "TextColor")
        
        currentSelectedCategory = viewTag
        
        // TODO: Aqui modificar la vista de recetas populares
    }
}

