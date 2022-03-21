//
//  NewIngredientTableViewCellTableViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class NewIngredientTableViewCellTableViewCell: UITableViewCell {
    static let identifier = String(describing: NewIngredientTableViewCellTableViewCell.self)
    
    @IBOutlet weak var ingredientIcon: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientInput: UITextField!
    @IBOutlet weak var ingredientUnits: UILabel!
    @IBOutlet weak var deleteIngredientbutton: UIButton!
    
    func setup(_ ingredient: Ingredient) {
        ingredientIcon.image = UIImage(named: "ing_carrot") // TODO: Cambiar
        ingredientName.text = ingredient.name
        ingredientUnits.text = ingredient.unit
        ingredientInput.text = ingredient.quantity ?? -1 == -1 ? "" : String(ingredient.quantity!) == "0" ? "" : String(ingredient.quantity!)
        
        self.addDoneButtonOnKeyboard()
        
        ingredientInput.setLeftPaddingPoints(10)
        ingredientInput.setRightPaddingPoints(10)
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

        ingredientInput.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            ingredientInput.resignFirstResponder()
        }
    
    @IBAction func deleteRowAction(_ sender: UIButton) {
        // TODO: Hacer
    }
}
