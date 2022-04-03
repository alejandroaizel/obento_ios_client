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
    
    
    var currentSelectedCategory = 0;
    
    // UI Elements
    var featuredRecipe: Recipe?
    var categories: [UIView] = [] //TODO: Change this for the below line
    //var categories: [String]
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateController = DateController()
        let userId: Int = 1
        
        // Featured recipe
        Task {
            featuredRecipe = await ObentoApi.getFeaturedRecipe(
                id: 1,
                userId: userId,
                date: dateController.currentDay().toString(),
                isLunch: true
            )
            loadFeatureRecipe()
            
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(clickView(_:))
            )
            tapGesture.delegate = self
            featuredRecipeView.addGestureRecognizer(tapGesture)
        }
        
        // Categories
        Task {
            //categories = await ObentoApi.getRecipesByCategory()
            categories = [
                allCategory,
                riceCategory,
                pastaCategory,
                vegetablesCategory,
                meatCategory,
                fishCategory
            ]
            loadCategories()
        }
        
        // Recipes
        Task {
            recipes = await ObentoApi.getRecipes()
            registerCells()
        }
        
    }
    
    func loadFeatureRecipe() {
        featuredRecipeTitle.text = featuredRecipe?.name
        featuredRecipekcal.text = "\(featuredRecipe?.kcalories ?? 0) kcal"
        featuredRecipeTime.text = "\(featuredRecipe?.cookingTime ?? 0) min"
        featuredRecipePrice.text = "\(featuredRecipe?.estimatedCost ?? 0) €"
        featuredRecipeImage.image = UIImage(
            named: "\(featuredRecipe?.imagePath ?? "recipe_1")"
        ) // FIXME: Change this
    }
    
    func loadCategories() {
        for i in 0..<categories.count {
            categories[i].tag = i
            
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(clickCategory(_:))
            )
            tapGesture.delegate = self
            categories[i].addGestureRecognizer(tapGesture)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let controller = RecipeViewController.instantiate()
        controller.recipeInformation = recipes[indexPath.row]

        present(controller, animated: true, completion: nil)
    }
    
    private func registerCells() {
        popularCollectionView.register(
            UINib(nibName: PopularRecipesCollectionViewCell.identifier,
                  bundle: nil),
            forCellWithReuseIdentifier:
                PopularRecipesCollectionViewCell.identifier
        )
    }
    
    @objc func clickView(_ sender: UIView) {
        let controller = (
            storyboard?.instantiateViewController(
                withIdentifier: "RecipeViewController")
        ) as! RecipeViewController
        
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return recipes.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PopularRecipesCollectionViewCell.identifier,
            for: indexPath
        ) as! PopularRecipesCollectionViewCell
        cell.setup(recipes[indexPath.row])
        
        return cell
    }
}

