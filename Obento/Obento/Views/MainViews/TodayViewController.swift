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
    
    // Popular Recipes
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    var featuredRecipe = Recipe(id: 0, userId: 0, name: "Sopa de çorba con chuletillas de cordero", description: "", puntuaction: 4.7, kcal: 350, time: 140, price: 6.5, isLaunch: true, imagePath: "recipe_6", type: "", servings: 1, ingredients: [], steps: [])
    var categories: [UIView] = []
    var recipes: [Recipe] = [ // TODO: ELIMINAR, PRUEBAS
        .init(id: 0, userId: 0, name: "Salmorejo con picatostes y jamón", description: "", puntuaction: 3.3, kcal: 0, time: 0, price: 0, isLaunch: true, imagePath: "recipe_1", type: "", servings: 1, ingredients: [], steps: []),
        .init(id: 0, userId: 0, name: "Sopa de pescado", description: "", puntuaction: 4.9, kcal: 0, time: 0, price: 0, isLaunch: true, imagePath: "recipe_2", type: "", servings: 1, ingredients: [], steps: []),
        .init(id: 0, userId: 0, name: "Ajoblanco malagueño con ahumados", description: "", puntuaction: 5.1, kcal: 0, time: 0, price: 0, isLaunch: true, imagePath: "recipe_3", type: "", servings: 1, ingredients: [], steps: []),
        .init(id: 0, userId: 0, name: "Arroz con marisco y verduras", description: "", puntuaction: 2.6, kcal: 0, time: 0, price: 0, isLaunch: true, imagePath: "recipe_4", type: "", servings: 1, ingredients: [], steps: []),
        .init(id: 0, userId: 0, name: "Ensalada japonesa", description: "", puntuaction: 4.3, kcal: 0, time: 0, price: 0, isLaunch: true, imagePath: "recipe_5", type: "", servings: 1, ingredients: [], steps: [])
    ]
    
    var currentSelectedCategory = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = [allCategory, riceCategory, pastaCategory, vegetablesCategory, meatCategory, fishCategory]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self
        
        featuredRecipeView.addGestureRecognizer(tapGesture)
        
        loadFeatureRecipe()
        loadCategories()
        registerCells()
        
    }
    
    func loadFeatureRecipe() {
        featuredRecipeTitle.text = featuredRecipe.name
        featuredRecipekcal.text = String(featuredRecipe.kcal) + " kcal"
        featuredRecipeTime.text = String(featuredRecipe.time) + " min"
        featuredRecipePrice.text = String(featuredRecipe.price) + " €"
        featuredRecipeImage.image = UIImage(named: featuredRecipe.imagePath) // FIXME: Change this
    }
    
    func loadCategories() {
        for i in 0..<categories.count {
            categories[i].tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickCategory(_:)))
            tapGesture.delegate = self
            
            categories[i].addGestureRecognizer(tapGesture)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = RecipeViewController.instantiate()
        controller.recipeInformation = recipes[indexPath.row]
        
        present(controller, animated: true, completion: nil)
    }
    
    private func registerCells() {
        popularCollectionView.register(UINib(nibName: PopularRecipesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PopularRecipesCollectionViewCell.identifier)
    }
    
    @objc func clickView(_ sender: UIView) {
        let controller = (storyboard?.instantiateViewController(withIdentifier: "RecipeViewController")) as! RecipeViewController
        
        controller.recipeInformation = featuredRecipe
        
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

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularRecipesCollectionViewCell.identifier, for: indexPath) as! PopularRecipesCollectionViewCell
        
        cell.setup(recipes[indexPath.row])
        
        return cell
    }
}

