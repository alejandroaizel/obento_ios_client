//
//  MenuCommonStep1ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class MenuCommonStep1ViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var firstDate: UIDatePicker!
    @IBOutlet weak var secondDate: UIDatePicker!
    
    var optionSelected: Int!
    var currentMenu: MenuSimple!
    var dateController: DateController = DateController()
    var currentNumDays: Int = 1
    var isDateCorect: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessage.isHidden = true
        
        firstDate.addTarget(self, action: #selector(firstDatePickerChanged(picker:)), for: .valueChanged)
        
        secondDate.addTarget(self, action: #selector(secondDatePickerChanged(picker:)), for: .valueChanged)
        
        optionSelected = MenuNavigationController.optionSelected
    }
    
    @objc func firstDatePickerChanged(picker: UIDatePicker) {
        let calendar = Calendar.current
        
        let firstDate = firstDate.date
        let secondDate = secondDate.date
        isDateCorect = dateIsGreater(is: secondDate, greaterThan: firstDate)
        
        if isDateCorect {
            currentNumDays = calendar.dateComponents([.day], from: firstDate, to: secondDate).day!
        }
        
        displayMessage()
    }
    
    @objc func secondDatePickerChanged(picker: UIDatePicker) {
        let calendar = Calendar.current
        
        let firstDate = firstDate.date
        let secondDate = secondDate.date
        isDateCorect = dateIsGreater(is: secondDate, greaterThan: firstDate)
        
        if isDateCorect {
            currentNumDays = calendar.dateComponents([.day], from: firstDate, to: secondDate).day!
        }
        
        displayMessage()
    }
    
    func displayMessage() {
        if isDateCorect {
            if currentNumDays > 14 {
                errorMessage.text = "Para poder continuar, selecciona un rango de un máximo de 2 semanas."
                errorMessage.isHidden = false
                nextButton.alpha = 0.4
            } else {
                errorMessage.isHidden = true
                nextButton.alpha = 1
            }
        } else {
            errorMessage.text = "Para poder continuar, la segunda fecha debe ser superior o igual que la primera."
            errorMessage.isHidden = false
            nextButton.alpha = 0.4
        }
    }
    
    func dateIsGreater(is firstDate: Date, greaterThan secondDate: Date) -> Bool {
        let formattedFirstDate = dateController.formatDay(firstDate)
        let formattedSecondDate = dateController.formatDay(secondDate)
        
        if formattedFirstDate.year > formattedSecondDate.year {
            return true
        } else {
            if formattedFirstDate.month > formattedSecondDate.month {
                return true
            } else {
                if formattedFirstDate.day >= formattedSecondDate.day {
                    return true
                }
            }
        }
        
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func storeMenu() {
        let firstFormatedDay = dateController.formatDay(firstDate.date)
        let secondFormatedDay = dateController.formatDay(secondDate.date)
        
        currentMenu = MenuSimple(user: 2, date: "07-05-22|08-05-22", discarded_ingredients: [])
        
//        currentMenu = .init(numDays: currentNumDays, startDay: firstFormatedDay, endDay: secondFormatedDay, recipes: [])
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        //callExample()
        
        if !isDateCorect || currentNumDays > 14 {
            return
        }
        
        if optionSelected == 0 { // Menú simple
            let vc = storyboard?.instantiateViewController(withIdentifier: "MenuCustomStep2ViewController") as! MenuCustomStep2ViewController
            
            storeMenu()
            
            vc.currentMenu = self.currentMenu
            
            self.navigationController?.pushViewController (vc, animated: true)
        } else {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "MenuCustomStep3ViewController") as! MenuCustomStep3ViewController
//
//            storeMenu()
//
//            vc.currentMenu = self.currentMenu
//            
//            self.navigationController?.pushViewController (vc, animated: true)
        }
    }
    
}
