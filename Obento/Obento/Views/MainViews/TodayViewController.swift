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
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var allCategory: UIView!
    
    // Popular Recipes
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    var currentSelectedCategory: Int = 0
    
    // UI Elements
    var featuredRecipe: Recipe?
    var categories: [String] = []
    var recipes: [Recipe] = []
    var popularRecipes: [Recipe] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        registerCells()
        
        // Featured recipe
        Task {
            self.featuredRecipe = await ObentoApi.getRecipe(id: 35)
            if (featuredRecipe != nil) {
                loadFeatureRecipe()
                // Add listener
                let tapGesture = UITapGestureRecognizer(
                    target: self,
                    action: #selector(clickView(_:))
                )
                tapGesture.delegate = self
                featuredRecipeView.addGestureRecognizer(tapGesture)
            } else {
                
                loadFeatureRecipe()
            }
        }
        
        // Categories
        Task {
            self.categories = await ObentoApi.getRecipeCategories()
            loadCategories()
        }
        
        // Recipes
        Task {
            self.recipes = await Recipe.popularRecipes()
            await updatePopularRecipesByCategory(category: 0)
        }
    }
    
    // FEATURE RECIPE METHODS

    func loadFeatureRecipe() {
        if (featuredRecipe != nil) {
            featuredRecipeImage.image = UIImage(data: featuredRecipe!.image)
        } else {
            featuredRecipeImage.image = UIImage(named: "default_recipe_image")!
        }
        featuredRecipeTitle.text = featuredRecipe?.name ?? "Receta destacada"
        featuredRecipekcal.text = "\(featuredRecipe?.kcalories.rounded().clean ?? "0") kcal"
        featuredRecipeTime.text = "\(featuredRecipe?.cookingTime ?? 0) min"
        featuredRecipePrice.text = "\(featuredRecipe?.estimatedCost ?? 0) €"
    }
    
    @objc func clickView(_ sender: UIView) {
        let controller = (
            storyboard?.instantiateViewController(
                withIdentifier: "RecipeViewController")
        ) as! RecipeViewController
        
        controller.recipeInformation = featuredRecipe
        present(controller, animated: true, completion: nil)
    }
    
    // CATEGORIES METHODS
    
    func loadCategories() {
        // Create listener
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(clickCategory(_:))
        )
        tapGesture.delegate = self

        // Create "all" category
        allCategory.tag = 0
        allCategory.addGestureRecognizer(tapGesture)
        
        // Add rest of categories (from API) to stack
        for i in 0..<categories.count {
            // Use Allcategories as template
            let labelCategory = createLabelCategory(
                template: allCategory,
                categoryName: categories[i]
            )
            labelCategory.tag = i + 1
            
            // Create listener
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(clickCategory(_:))
            )
            tapGesture.delegate = self
            labelCategory.addGestureRecognizer(tapGesture)
            
            // Add view to stack
            categoryStack.addArrangedSubview(labelCategory)
            categoryStack.addSubview(labelCategory)
        }
        categoryStack.sizeToFit()
    }
    
    // Clone and setting a new category view
    private func createLabelCategory(
        template: UIView,
        categoryName: String
    ) -> UIView {
        // Copy template
        let aux: UIView = allCategory.copyView()
        // Set corner radius and tag
        aux.cornerRadius = 20.0
        aux.layoutMargins = UIEdgeInsets(
            top: 0, left: 0, bottom: 0, right: 20
        )
        // Set name and colors
        let textLabel = aux.subviews[0] as! UILabel
        textLabel.text = categoryName
        textLabel.textColor =  UIColor(named: "TextColor")
        aux.backgroundColor = UIColor(named: "SecondaryColor")
        
        return aux
    }

    @objc func clickCategory(_ sender: UITapGestureRecognizer) {
        let senderView = sender.view!
        let viewTag = senderView.tag
        // Select new label
        selectLabel(tag: viewTag)
        // Unselect old label
        unselectLabel(tag: currentSelectedCategory)
        // Update selected category value
        currentSelectedCategory = viewTag
        
        Task {
            await updatePopularRecipesByCategory(
                category: currentSelectedCategory
            )
        }
    }

    private func selectLabel(tag: Int) {
        for view in categoryStack.subviews {
            if (view.tag == tag) {
                view.backgroundColor = UIColor(named: "ObentoGreen")
                let viewLabel: UILabel = view.subviews[0] as! UILabel
                viewLabel.textColor = .white
                break
            }
        }
    }
    
    private func unselectLabel(tag: Int) {
        for view in categoryStack.subviews {
            if (view.tag == tag) {
                view.backgroundColor = UIColor(named: "SecondaryColor")
                let viewLabel: UILabel = view.subviews[0] as! UILabel
                viewLabel.textColor = UIColor(named: "TextColor")
                break
            }
        }
    }
    
    // POPULAR RECIPES METHODS
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        //let controller = RecipeViewController.instantiate()
        let controller = storyboard?.instantiateViewController(
            withIdentifier: "RecipeViewController"
        ) as! RecipeViewController
        controller.recipeInformation = recipes[indexPath.row]
        
        present(controller, animated: true, completion: nil)
    }
    
    private func registerCells() {
        popularCollectionView.register(
            UINib(
                nibName: PopularRecipesCollectionViewCell.identifier,
                bundle: nil
            ),
            forCellWithReuseIdentifier: PopularRecipesCollectionViewCell.identifier
        )
    }
    
    private func updatePopularRecipesByCategory(category: Int) async {
        switch category {
        // Arroz
        case 1:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 1)
            self.popularCollectionView.reloadData()
            break
        // Bocadillos
        case 2:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 2)
            self.popularCollectionView.reloadData()
            break
        // Carnes
        case 3:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 3)
            self.popularCollectionView.reloadData()
            break
        // Ensaldas y bowls
        case 4:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 4)
            self.popularCollectionView.reloadData()
            break
        // Guisos
        case 5:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 5)
            self.popularCollectionView.reloadData()
            break
        // Legumbres
        case 6:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 6)
            self.popularCollectionView.reloadData()
            break
        // Pastas
        case 7:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 7)
            self.popularCollectionView.reloadData()
            break
        // Pescado
        case 8:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 8)
            self.popularCollectionView.reloadData()
            break
        // Salteado
        case 9:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 9)
            self.popularCollectionView.reloadData()
            break
        // Sandwich
        case 10:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 10)
            self.popularCollectionView.reloadData()
            break
        // Sopa y crema
        case 11:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 11)
            self.popularCollectionView.reloadData()
            break
        // Verduras
        case 12:
            self.recipes = await ObentoApi.getRecipesByCategory(category: 12)
            self.popularCollectionView.reloadData()
            break
        // Todo
        default:
            self.recipes = await Recipe.popularRecipes()
            self.popularCollectionView.reloadData()
            break
        }

        DispatchQueue.main.async {
            self.popularCollectionView.reloadData()
        }
    }
    
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.recipes.count
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

extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(
            with: NSKeyedArchiver.archivedData(withRootObject: self)
        ) as! T
    }
}
