//
//  MenuCommonStep4ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class MenuCommonStep4ViewController: UIViewController {
    @IBOutlet weak var rangeDays: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var finalImage: UIImageView!
    
    var currentMenu: Menu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeDays.text = String(currentMenu.startDay.day) + "/" + String(currentMenu.startDay.month) + " - " + String(currentMenu.endDay.day) + "/" + String(currentMenu.endDay.month)
        
        finalImage.image = UIImage(named: "new_recipe_final_illustration_" + String(Int.random(in: 1...4)))
        
        Task {
            let is_simple_menu = currentMenu.maxTime == nil
            
            if is_simple_menu {
                let menu_simple: MenuSimple = processSimpleMenu(currentMenu: currentMenu)
                
                await ObentoApi.postMenuSimple(menu: menu_simple)
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: "updateMenu"), object: nil
                )
            } else {
                let menu_complex: MenuComplex = processComplexMenu(currentMenu: currentMenu)
                
                await ObentoApi.postMenuComplex(menu: menu_complex)
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: "updateMenu"), object: nil
                )
            }
        }
    }
    
    func processSimpleMenu(currentMenu: Menu) -> MenuSimple {
        let starting_date = String(format: "%02d-%02d-%02d", currentMenu.startDay.day, currentMenu.startDay.month, currentMenu.startDay.year % 100)
        
        let ending_date = String(format: "%02d-%02d-%02d", currentMenu.endDay.day, currentMenu.endDay.month, currentMenu.endDay.year % 100)
        
        let range_date = starting_date + "|" + ending_date
        
        return MenuSimple(user: 2, date: range_date)
    }
    
    func processComplexMenu(currentMenu: Menu) -> MenuComplex {
        let starting_date = String(format: "%02d-%02d-%02d", currentMenu.startDay.day, currentMenu.startDay.month, currentMenu.startDay.year % 100)
        
        let ending_date = String(format: "%02d-%02d-%02d", currentMenu.endDay.day, currentMenu.endDay.month, currentMenu.endDay.year % 100)
        
        let range_date = starting_date + "|" + ending_date
        
        var discarded_ingredients: [Int] = []
        let is_lunch = (currentMenu.availableRecipesTime == 0 || currentMenu.availableRecipesTime == 1) ? true : false
        
        for ingredient in currentMenu.bannedIngredients! {
            discarded_ingredients.append(ingredient.id)
        }
        
        return MenuComplex(
            user: 2,
            date: range_date,
            discarded_ingredients: discarded_ingredients,
            max_time: currentMenu.maxTime!,
            max_price: currentMenu.maxPrice!,
            is_lunch: is_lunch
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
