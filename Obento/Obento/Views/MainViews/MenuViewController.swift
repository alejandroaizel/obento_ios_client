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
    @IBOutlet weak var addmenuButton: UIButton!
    
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
    
    var selectedDay: DateController.FormattedDate = .init(
        numberDay: -1,
        numberMonth: -1,
        numberYear: -1,
        nameDay: "",
        nameMonth: "",
        nameYear: ""
    )
    var dateController: DateController = DateController()
    var currentWeekNumber: Int = 0
    var currentWeek: [DateController.FormattedDate] = []
    var currentMenu: [MenuItem] = []
    var isLunchToogle: Bool = true
    var currentRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addmenuButton.showsMenuAsPrimaryAction = true
        addmenuButton.menu = addMenuItems()
        
        selectedDay = dateController.currentDate()
        
        Task {
            currentMenu = await ObentoApi.getMenu(userId: 2)
            loadWeek()
            updateWeek()
            loadCurrentRecipe()
        }
    }
    
    func loadCurrentRecipe() {
        if let currentMenuItem: MenuItem = MenuItem.getItem(
            menuItems: self.currentMenu,
            date: DateController.getDate(date: self.selectedDay),
            isLunch: isLunchToogle
        ) {
            self.currentRecipe = currentMenuItem.recipe
            loadCurrentRecipePreview()
        } else {
            self.currentRecipe = nil
            loadDefaultRecipe()
        }
    }
    
    func loadCurrentRecipePreview(){
        // Fill recipe data
        recieTitle.text = self.currentRecipe!.name
        recipeImage.image = UIImage(data: self.currentRecipe!.image)
        recipePuntuation.text = "\(self.currentRecipe!.starts)"
        recipeDescription.text = self.currentRecipe!.description
    }
    
    func loadDefaultRecipe() {
        // Fill recipe data
        recieTitle.text = "Sin receta"
        recipeImage.image = UIImage(named: "default_recipe_image")
        recipePuntuation.text = "--"
        recipeDescription.text = "¡Vaya! Todavía no has creado un menú para este día. Crear un nuevo menú es muy sencillo ¡Tan solo tienes que pulsar sobre el botón '+' y nosotros haremos el resto!"
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
        loadCurrentRecipe()
    }
    
    func updateWeek() {
        currentWeek = dateController.getWeek(for: currentWeekNumber)
        
        let month = dateController.winnerMonth(from: currentWeek)
        let year = currentWeek[0].nameMonth == month ? currentWeek[0].numberYear : currentWeek[currentWeek.count - 1].numberYear
        
        date.text = month.capitalizingFirstLetter() + ", " + String(year)
        
//        recieTitle.text = currentRecipe?.name ?? "Null"
//        recipeImage.image = UIImage(named: "recipe_1")
//        recipePuntuation.text = String(5) // TODO: score
//        recipeDescription.text = currentRecipe?.description ?? "Null"
        
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
        if self.currentRecipe != nil {
            let controller = (storyboard?.instantiateViewController(withIdentifier: "RecipeViewController")) as! RecipeViewController
            controller.recipeInformation = currentRecipe
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func lunchToggleAction(_ sender: Any) {
        dinnerToggleButton.backgroundColor = UIColor(named: "clearColor")
        dinnerToggleButton.tintColor = UIColor(named: "PrimaryColor")
        dinnerToggleButton.setImage(UIImage(systemName: "moon"), for: .normal)
        
        lunchToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        lunchToggleButton.tintColor = .white
        lunchToggleButton.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
        
        isLunchToogle = true
        loadCurrentRecipe()
    }
    
    @IBAction func dinnerToggleAction(_ sender: Any) {
        lunchToggleButton.backgroundColor = UIColor(named: "clearColor")
        lunchToggleButton.tintColor = UIColor(named: "PrimaryColor")
        lunchToggleButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
        
        dinnerToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        dinnerToggleButton.tintColor = .white
        dinnerToggleButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        
        isLunchToogle = false
        loadCurrentRecipe()
    }

    @IBAction func previousWeekAction(_ sender: Any) {
        currentWeekNumber -= 1
        updateWeek()
    }
    
    @IBAction func nextWeekAction(_ sender: Any) {
        currentWeekNumber += 1
        updateWeek()
    }
    
    /*@IBAction func addMenuAction(_ sender: Any) {
    }*/
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Nuevo menú simple", image: UIImage(systemName: "menubar.rectangle"), handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuNavigationController") as! MenuNavigationController
                MenuNavigationController.optionSelected = 0
                self.present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Nuevo menú personalizado", image: UIImage(systemName: "filemenu.and.selection"), handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuNavigationController") as! MenuNavigationController
                MenuNavigationController.optionSelected = 1
                self.present(vc, animated: true, completion: nil)
            })
        ])
        
        return menuItems
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
