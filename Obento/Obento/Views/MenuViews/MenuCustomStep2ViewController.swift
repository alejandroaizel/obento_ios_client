//
//  MenuCustomStep2ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class MenuCustomStep2ViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var ingredientsCollection: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentMenu: MenuSimple!
    
    var currentRecipe: Recipe!
    var ingredientList: [Ingredient]!
    var filteredIngredients: [Ingredient] = []
    var currentIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        
        Task {
            self.ingredientList = await ObentoApi.getIngredients()
            self.filteredIngredients = self.ingredientList
            
            self.addDoneButtonOnKeyboard()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
            self.view.addGestureRecognizer(tapGesture)
            tapGesture.cancelsTouchesInView = false
            
            searchBar.setLeftPaddingPoints(40)
            searchBar.setRightPaddingPoints(15)
            searchBar.addTarget(self, action: #selector(filterIngredients), for: .editingChanged)
            
            registerCells()
            self.ingredientsCollection.reloadData()
        }
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
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuCommonStep4ViewController") as! MenuCommonStep4ViewController

        vc.currentMenu = self.currentMenu
        
        for ingredient in filteredIngredients {
            currentMenu.discarded_ingredients.append(ingredient.id)
        }
        
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
    }
}

extension MenuCustomStep2ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.identifier, for: indexPath) as! IngredientCollectionViewCell
        
        cell.setup(self.filteredIngredients[indexPath.row])
        cell.tag = self.filteredIngredients[indexPath.row].id
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedIngredient: Ingredient = self.filteredIngredients[indexPath.row]
        
        for ing in currentIngredients {
            if selectedIngredient.id == ing.id {
                return
            }
        }
        
        selectedIngredient.quantity = 0
        nextButton.alpha = 1
        
        self.currentIngredients.append(selectedIngredient)
    }
}
