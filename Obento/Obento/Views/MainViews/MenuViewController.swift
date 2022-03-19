//
//  MenuViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 5/3/22.
//

import UIKit

/// The view controller for the menu tab
class MenuViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var lunchToggleButton: UIButton!
    @IBOutlet weak var dinnerToggleButton: UIButton!
    @IBOutlet weak var previousWeekButton: UIButton!
    @IBOutlet weak var nextWeekButton: UIButton!
    
    @IBOutlet weak var recipePreviewView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recieTitle: UILabel!
    @IBOutlet weak var recipePuntuation: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var monday: UIView!
    @IBOutlet weak var tuesday: UIView!
    @IBOutlet weak var wednesday: UIView!
    @IBOutlet weak var thursday: UIView!
    @IBOutlet weak var friday: UIView!
    @IBOutlet weak var saturday: UIView!
    @IBOutlet weak var sunday: UIView!
    
    @IBOutlet var daysOfWeek: Array<UIView>?
    
    var selectedDay: DateController.FormattedDate = .init(numberDay: -1, numberMonth: -1, numberYear: -1, nameDay: "", nameMonth: "", nameYear: "")
    var dateController: DateController = DateController()
    var currentWeekNumber: Int = 0
    var currentWeek: [DateController.FormattedDate] = []
    var currentRecipe: Recipe = Recipe(id: 0, userId: 0, name: "Sopa de çorba con chuletillas de cordero", description: "Disfruta de este exquisito plato de la cocina árabe tradicional muy ideal para estas épocas frias.", puntuaction: 4.7, kcal: 350, time: 140, price: 6.5, isLaunch: true, imagePath: "recipe_6", type: "", ingredients: [], steps: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDay = dateController.currentDate()
        
        loadWeek()
        updateWeek()
    }
    
    func loadWeek() {
        for i in 0..<daysOfWeek!.count {
            daysOfWeek![i].tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clicDay(_:)))
            tapGesture.delegate = self
            
            daysOfWeek![i].addGestureRecognizer(tapGesture)
            
            daysOfWeek![i].layer.shadowColor = UIColor.black.cgColor
            daysOfWeek![i].layer.shadowOpacity = 0
            daysOfWeek![i].layer.shadowOffset = .zero
            daysOfWeek![i].layer.shadowRadius = 10
        }
        
        recipePreviewView.layer.shadowColor = UIColor.black.cgColor
        recipePreviewView.layer.shadowOpacity = 0.075
        recipePreviewView.layer.shadowOffset = .zero
        recipePreviewView.layer.shadowRadius = 10
        
        recipeImage.layer.cornerRadius = 30
        recipeImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self
        
        recipePreviewView.addGestureRecognizer(tapGesture)
    }
    
    @objc func clicDay(_ sender: UITapGestureRecognizer) {
        let senderView = sender.view!
        let viewTag = senderView.tag
        
        selectedDay = currentWeek[viewTag]
        updateWeek()
        
        // TODO: Cambiar selectedRecipe
    }
    
    func updateWeek() {
        currentWeek = dateController.getWeek(for: currentWeekNumber)
        
        let month = dateController.winnerMonth(from: currentWeek)
        
        let year = currentWeek[0].nameMonth == month ? currentWeek[0].numberYear : currentWeek[currentWeek.count - 1].numberYear
        
        date.text = month.capitalizingFirstLetter() + ", " + String(year)
        
        recieTitle.text = currentRecipe.name
        recipeImage.image = UIImage(named: currentRecipe.imagePath)
        recipePuntuation.text = String(currentRecipe.puntuaction)
        recipeDescription.text = currentRecipe.description
        
        for i in 0..<7 {
            (daysOfWeek![i].subviews[0] as! UILabel).text = String(currentWeek[i].numberDay)
            
            if currentWeek[i] == selectedDay {
                daysOfWeek![i].backgroundColor = UIColor(named: "ObentoGreen")
                (daysOfWeek![i].subviews[0] as! UILabel).textColor = .white
                (daysOfWeek![i].subviews[1] as! UILabel).textColor = .white
                daysOfWeek![i].layer.shadowOpacity = 0.1
                
                continue
            }
            
            daysOfWeek![i].backgroundColor = UIColor.black.withAlphaComponent(0.0)
            daysOfWeek![i].layer.shadowOpacity = 0
            
            if month == currentWeek[i].nameMonth {
                (daysOfWeek![i].subviews[0] as! UILabel).textColor = UIColor(named: "PrimaryColor")
                (daysOfWeek![i].subviews[1] as! UILabel).textColor = UIColor(named: "PrimaryColor")
            } else {
                (daysOfWeek![i].subviews[0] as! UILabel).textColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.5)
                (daysOfWeek![i].subviews[1] as! UILabel).textColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.5)
            }
        }
    }
    
    @objc func clickView(_ sender: UIView) {
        let controller = (storyboard?.instantiateViewController(withIdentifier: "RecipeViewController")) as! RecipeViewController
        
        controller.recipeInformation = currentRecipe
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func lunchToggleAction(_ sender: Any) {
        dinnerToggleButton.backgroundColor = UIColor(named: "clearColor")
        dinnerToggleButton.tintColor = UIColor(named: "PrimaryColor")
        dinnerToggleButton.setImage(UIImage(systemName: "moon"), for: .normal)
        
        lunchToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        lunchToggleButton.tintColor = .white
        lunchToggleButton.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
        
        // TODO: Cambiar selectedRecipe
    }
    
    @IBAction func dinnerToggleAction(_ sender: Any) {
        lunchToggleButton.backgroundColor = UIColor(named: "clearColor")
        lunchToggleButton.tintColor = UIColor(named: "PrimaryColor")
        lunchToggleButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
        
        dinnerToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        dinnerToggleButton.tintColor = .white
        dinnerToggleButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        
        // TODO: Cambiar selectedRecipe
    }
    
    @IBAction func previousWeekAction(_ sender: Any) {
        currentWeekNumber -= 1
        updateWeek()
    }
    
    @IBAction func nextWeekAction(_ sender: Any) {
        currentWeekNumber += 1
        updateWeek()
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
