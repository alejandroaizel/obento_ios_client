//
//  RecipeManualStep3ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class RecipeManualStep3ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableHeightCons: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ingredientsCollection: UICollectionView!
    @IBOutlet weak var selectedIngredientsTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    var currentRecipe: Recipe!
    var ingredientList: [Ingredient]!
    var filteredIngredients: [Ingredient] = []
    var currentIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            ingredientList = await ObentoApi.getIngredients()
            filteredIngredients = ingredientList
        }

        nextButton.alpha = 0.4
        
        self.addDoneButtonOnKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        searchBar.setLeftPaddingPoints(40)
        searchBar.setRightPaddingPoints(15)
        searchBar.addTarget(self, action: #selector(filterIngredients), for: .editingChanged)
        
        registerCells()

        // Do any additional setup after loading the view.
    }
    
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.backgroundColor = .systemBackground

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

        searchBar.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            searchBar.resignFirstResponder()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.contentInset.bottom = 0
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if currentIngredients.count == 0 {
            return
        }
    
        let auxIngredients: [Ingredient] = []
        
        let i: Int = 0
        for rowPath in selectedIngredientsTableView.indexPathsForVisibleRows! {
            let cell = selectedIngredientsTableView.cellForRow(at: rowPath)
            let _: Ingredient = currentIngredients[i]

            let ingredientQuantity: Int = Int((cell as! NewIngredientTableViewCellTableViewCell).ingredientInput.text ?? "-1") ?? -1
            
            if ingredientQuantity == -1 {
                continue
            }
            
            /*
             auxIngredients.append(.init(id: currentIngredient.id, name: currentIngredient.name, category: currentIngredient.category, unitaryPrice: currentIngredient.unitaryPrice, unit: currentIngredient.unit, kcal: currentIngredient.kcal, iconPath: currentIngredient.iconPath, quantity: ingredientQuantity))
            
            i += 1
            */ //TODO: Use new Ingredient object
        }
        
        currentRecipe.ingredients = auxIngredients
        
        if currentRecipe.ingredients.count == 0 {
            nextButton.alpha = 0.4
            
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecipeManualStep4ViewController") as! RecipeManualStep4ViewController
        
        vc.currentRecipe = self.currentRecipe
        
        self.navigationController?.pushViewController (vc, animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    @objc func filterIngredients() {
        if searchBar.text!.isEmpty {
            filteredIngredients = ingredientList
        } else {
            filteredIngredients = getIngredients(startBy: searchBar.text!)
        }
        
        ingredientsCollection.reloadData()
    }
    
    func getIngredients(startBy initial: String) -> [Ingredient] {
        var aux: [Ingredient] = []
        
        for ingredient in ingredientList {
            if ingredient.name.lowercased().hasPrefix(initial.lowercased()) {
                aux.append(ingredient)
            }
        }
        
        return aux
    }
    
    private func registerCells() {
        ingredientsCollection.register(UINib(nibName: IngredientCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: IngredientCollectionViewCell.identifier)
        
        selectedIngredientsTableView.register(UINib(nibName: NewIngredientTableViewCellTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewIngredientTableViewCellTableViewCell.identifier)
    }

    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

}

extension RecipeManualStep3ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.identifier, for: indexPath) as! IngredientCollectionViewCell
        
        cell.setup(filteredIngredients[indexPath.row])
        cell.tag = filteredIngredients[indexPath.row].id
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedIngredient: Ingredient = filteredIngredients[indexPath.row]
        
        for ing in currentIngredients {
            if selectedIngredient.id == ing.id {
                return
            }
        }
        
        if currentIngredients.count > 1 {
            tableHeightCons.constant += 60.35
        }
        
        selectedIngredient.quantity = 0
        nextButton.alpha = 1
        
        var i: Int = 0
        for rowPath in selectedIngredientsTableView.indexPathsForVisibleRows! {
            let cell = selectedIngredientsTableView.cellForRow(at: rowPath)

            let ingredientQuantity: Int = Int((cell as! NewIngredientTableViewCellTableViewCell).ingredientInput.text ?? "-1") ?? -1
            
            currentIngredients[i].quantity = Float(ingredientQuantity)
            
            i += 1
        }
        
        currentIngredients.append(selectedIngredient)
        
        selectedIngredientsTableView.reloadData()
    }
}

extension RecipeManualStep3ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedIngredientsTableView.dequeueReusableCell(withIdentifier: NewIngredientTableViewCellTableViewCell.identifier) as! NewIngredientTableViewCellTableViewCell
        
        cell.setup(currentIngredients[indexPath.row])
        // cell.deleteIngredientbutton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
}
