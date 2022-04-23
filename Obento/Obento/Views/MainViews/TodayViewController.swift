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

    override func viewDidLoad() {
        super.viewDidLoad()

        let dateController = DateController()
        let userId: Int = 1
        
        // Featured recipe
        Task {
//            featuredRecipe = await ObentoApi.getFeaturedRecipe(
//                id: 1,
//                userId: userId,
//                date: dateController.currentDay().toString(),
//                isLunch: true
//            )
            featuredRecipe = await ObentoApi.getRecipe(id: 50)
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
                // TODO: show placeholder, something like
                // "Create your first menu to see here your recipe"
                // For the moment load default values
                loadFeatureRecipe()
            }
        }
        
        // Categories
        Task {
            categories = await ObentoApi.getRecipeCategories()
            loadCategories()
        }
        
        // Recipes
        Task {
            recipes = await ObentoApi.getRecipes()
            registerCells()
            popularCollectionView.reloadData()
        }
        
    }
    
    // FEATURE RECIPE METHODS
    
    func loadFeatureRecipe() {
        
        featuredRecipeImage.image = UIImage(data: featuredRecipe!.image) //TODO: set default value
        featuredRecipeTitle.text = featuredRecipe?.name ?? "Receta destacada"
        featuredRecipekcal.text = "\(featuredRecipe?.kcalories ?? 0) kcal"
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

        updatePopularRecipesByCategory(category: currentSelectedCategory)
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
        let controller = RecipeViewController.instantiate()
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
    
    private func updatePopularRecipesByCategory(category: Int) {
        switch category {
        // Arroz
        case 1:
            break
        // Bocadillos
        case 2:
            break
        // Carnes
        case 3:
            break
        // Ensaldas y bowls
        case 4:
            break
        // Guisos
        case 5:
            break
        // Legumbres
        case 6:
            break
        // Pastas
        case 7:
            break
        // Pescado
        case 8:
            break
        // Salteado
        case 9:
            break
        // Sandwich
        case 10:
            break
        // Sopa y crema
        case 11:
            break
        // Verduras
        case 12:
            break
        // Todo
        default:
            break
        }
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

extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(
            with: NSKeyedArchiver.archivedData(withRootObject: self)
        ) as! T
    }
}
