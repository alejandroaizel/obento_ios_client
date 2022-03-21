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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalStats()
        
        finalImage.image = UIImage(named: "new_recipe_final_illustration_" + String(Int.random(in: 1...4)))

        // TODO: GUARDAR EN BD LA RECETA
    }
    
    func finalStats() {
        var totalKcal: Int = 0
        var totalPrice: Double = 0.0
        
        for ing in currentRecipe.ingredients {
            totalKcal += ing.kcal * ing.quantity!
            totalPrice += ing.unitaryPrice * Double(ing.quantity!)
        }
        
        currentRecipe.kcal = totalKcal
        currentRecipe.price = totalPrice
        
        currentRecipe.puntuaction = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bottonCloseButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}