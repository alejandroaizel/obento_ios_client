//
//  RecipeViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

class RecipeViewController: UIViewController {
    // Buttons
    @IBOutlet weak var closeViewButton: UIButton!
    @IBOutlet weak var firstStarButton: UIButton!
    @IBOutlet weak var secondStarButton: UIButton!
    @IBOutlet weak var thirdStartButton: UIButton!
    @IBOutlet weak var fourthStartButton: UIButton!
    @IBOutlet weak var fifthStarButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    
    // Recipe Elements
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeType: UILabel!
    @IBOutlet weak var recipePuntuation: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeKcal: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipePrice: UILabel!
    
    // Recipe Ingredients and Steps
    @IBOutlet weak var stepsTableView: UITableView!
    @IBOutlet weak var ingredientsCollection: UICollectionView!
    
    // Others
    var recipeInformation: Recipe!
    var recipeStars: Int = 3 // TODO: Cambiar
    
    let exampleRecipe: Recipe = .init(id: 10, userId: 0, name: "Salmorejo cordobés tradicional", description: "Cuando hace unas semanas visité Córdoba, tuve el honor de ser nombrado embajador de la Cofradía del Salmorejo y no podía dejar pasar ese honor sin contaros cómo se hace la receta del salmorejo cordobés tradicional, una sopa fría con la que siempre quedo bien contento, especialmente en los días calurosos de primavera y verano.", puntuaction: 4.4, kcal: 235, time: 45, price: 2.5, isLaunch: true, imagePath: "recipe_1", type: "Sopas", servings: 1, ingredients: [
        .init(id: 0, name: "Tomate", category: "", unitaryPrice: 0.32, unit: "g", kcal: 20, iconPath: "ing_carrot", quantity: 200),
        .init(id: 1, name: "Pan", category: "", unitaryPrice: 0.61, unit: "uds", kcal: 35, iconPath: "ing_carrot", quantity: 10),
        .init(id: 1, name: "Aceite de oliva", category: "", unitaryPrice: 0.61, unit: "ml", kcal: 35, iconPath: "ing_carrot", quantity: 150),
        .init(id: 1, name: "Diente de ajo", category: "", unitaryPrice: 0.61, unit: "uds", kcal: 35, iconPath: "ing_carrot", quantity: 1),
        .init(id: 1, name: "Sal", category: "", unitaryPrice: 0.61, unit: "g", kcal: 35, iconPath: "ing_carrot", quantity: 5)
    ], steps: [
        "Comenzamos lavando los tomates, retirando lo verde del pedúnculo y triturándolos. No es necesario pelar ni quitar las pepitas porque después paso el puré de tomate por un colador fino donde se queda todo pasando solamente el tomate.",
        "En un bol se coloca el pan y se cubro con el puré de tomate dejando que se impregne durante unos diez minutos. Pasado ese tiempo, se incorpora el diente de ajo y se tritura bien con la batidora para obtener una crema espesa de pan y tomate.",
        "A continuación se incorpora el aceite de oliva virgen extra. Un buen salmorejo se debería hacer siempre con aceite de la zona de Córdoba, por lo que si podéis, cualquier variedad de la D.O. Priego de Córdoba es la idónea.",
        "Tras echar el aceite se vuelve a triturar con paciencia hasta que el salmorejo sea uniforme, con un bonito color anaranjado y suficientemente compacto como para aguantar sobre su superficie los tradicionales tropezones de guarnición con los que se decora cada ración.",
        "Se presenta en un plato junto con un chorrito de aceite de oliva."
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeInformation = exampleRecipe // TODO: ELIMINAR
        
        loadRecipeInformation()
        registerCells()
        
    }
    
    private func registerCells() {
        ingredientsCollection.register(UINib(nibName: IngredientCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: IngredientCollectionViewCell.identifier)
        
        stepsTableView.register(UINib(nibName: StepTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StepTableViewCell.identifier)
    }
    
    func loadRecipeInformation() {
        recipeImage.image = UIImage(named: recipeInformation.imagePath)
        recipeName.text = recipeInformation.name
        recipeType.text = recipeInformation.type
        recipePuntuation.text = String(recipeInformation.puntuaction)
        recipeDescription.text = recipeInformation.description
        recipeKcal.text = String(recipeInformation.kcal) + " kcal"
        recipeTime.text = String(recipeInformation.time) + " min"
        recipePrice.text = String(recipeInformation.price) + " €"
        
        colorStars(numStars: recipeStars)
        
        let currentRecipesAdded = UserDefaults.standard.object(forKey: "addedToCart") as? [Int] ?? []
        
        if currentRecipesAdded.contains(recipeInformation.id) {
            addCartButton.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
        }
    }
    
    // Buton functions
    @IBAction func closeViewButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fisrtStartClickAction(_ sender: Any) {
        colorStars(numStars: 1)
    }
    
    @IBAction func secondStarClickAction(_ sender: Any) {
        colorStars(numStars: 2)
    }
    
    @IBAction func thirdStarClickAction(_ sender: Any) {
        colorStars(numStars: 3)
    }

    @IBAction func fourthStarClickAction(_ sender: Any) {
        colorStars(numStars: 4)
    }
    
    @IBAction func fifthStarClickAction(_ sender: Any) {
        colorStars(numStars: 5)
    }
    
    @IBAction func addCartAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCartTableView"), object: recipeInformation.ingredients)
        
        addCartButton.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
        
        var currentRecipesAdded = UserDefaults.standard.object(forKey: "addedToCart") as? [Int] ?? []
        
        if !currentRecipesAdded.contains(recipeInformation.id) {
            currentRecipesAdded.append(recipeInformation.id)
            
            UserDefaults.standard.set(currentRecipesAdded, forKey: "addedToCart")
        }
    }
    
    func colorStars(numStars: Int) {
        var resetStars = false
        
        if numStars == 1 && recipeStars == 1 {
            firstStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            firstStarButton.tintColor = UIColor(named: "PrimaryColor")
            
            resetStars = true
            recipeStars = 0
        }
        
        if (!resetStars && 1 <= numStars) {
            firstStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            firstStarButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 1
        } else {
            firstStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            firstStarButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 2 <= numStars) {
            secondStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            secondStarButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 2
        } else {
            secondStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            secondStarButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 3 <= numStars) {
            thirdStartButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            thirdStartButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 3
        } else {
            thirdStartButton.setImage(UIImage(systemName: "star"), for: .normal)
            thirdStartButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 4 <= numStars) {
            fourthStartButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fourthStartButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 4
        } else {
            fourthStartButton.setImage(UIImage(systemName: "star"), for: .normal)
            fourthStartButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 5 <= numStars) {
            fifthStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fifthStarButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 5
        } else {
            fifthStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            fifthStarButton.tintColor = UIColor(named: "PrimaryColor")
        }
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeInformation.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.identifier, for: indexPath) as! IngredientCollectionViewCell
        
        cell.setup(recipeInformation.ingredients[indexPath.row])
        
        return cell
    }
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeInformation.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stepsTableView.dequeueReusableCell(withIdentifier: StepTableViewCell.identifier) as! StepTableViewCell
        
        cell.setup(Step(number: indexPath.row + 1, description: recipeInformation.steps[indexPath.row]))
        
        return cell
    }
}
