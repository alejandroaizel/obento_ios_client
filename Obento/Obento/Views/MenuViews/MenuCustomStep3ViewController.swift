//
//  MenuCustomStep3ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class MenuCustomStep3ViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var maxTimePicker: UIDatePicker!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var totalBudget: UILabel!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    
    var currentMenu: Menu!
    var lunchPressed = true
    var dinnerPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minusButton.alpha = 0.25

        navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuCommonStep4ViewController") as! MenuCommonStep4ViewController
        
        self.currentMenu.maxTime = Int(maxTimePicker.countDownDuration / 60)
        if self.currentMenu.maxPrice == nil {
            self.currentMenu.maxPrice = 1
        }
                
        if lunchPressed && dinnerPressed {
            self.currentMenu.availableRecipesTime = 0
        } else if lunchPressed && !dinnerPressed {
            self.currentMenu.availableRecipesTime = 1
        } else if !lunchPressed && dinnerPressed {
            self.currentMenu.availableRecipesTime = 2
        }

        vc.currentMenu = self.currentMenu
        
        if lunchPressed || dinnerPressed {
            self.navigationController?.pushViewController (vc, animated: true)
        }
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        if currentMenu.maxPrice ?? 0 > 1{
            currentMenu.maxPrice! -= 1
            
            minusButton.alpha = 1
        } else {
            currentMenu.maxPrice = 1
        }
        
        if currentMenu.maxPrice ?? 0 == 1 {
            minusButton.alpha = 0.25
        }
        
        totalBudget.text = String(currentMenu.maxPrice!) + " €"
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        if currentMenu.maxPrice ?? 0 >= 1{
            currentMenu.maxPrice! += 1
        } else {
            currentMenu.maxPrice = 2
        }
        
        minusButton.alpha = 1
        
        totalBudget.text = String(currentMenu.maxPrice!) + " €"
    }
    
    @IBAction func lunchButtonAction(_ sender: Any) {
        lunchPressed = !lunchPressed
        
        if lunchPressed {
            lunchButton.backgroundColor = UIColor(named: "ObentoGreen")
            lunchButton.tintColor = .white
        } else {
            lunchButton.backgroundColor = UIColor(named: "SecondaryColor")
            lunchButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if lunchPressed && !dinnerPressed {
            currentMenu.availableRecipesTime = 0
        } else if !lunchPressed && dinnerPressed {
            currentMenu.availableRecipesTime = 1
        } else {
            currentMenu.availableRecipesTime = 2
        }
        
        if !lunchPressed && !dinnerPressed {
            nextButton.alpha = 0.25
        } else {
            nextButton.alpha = 1
        }
    }
    
    @IBAction func dinnerButtonAction(_ sender: Any) {
        dinnerPressed = !dinnerPressed
        
        if dinnerPressed {
            dinnerButton.backgroundColor = UIColor(named: "ObentoGreen")
            dinnerButton.tintColor = .white
        } else {
            dinnerButton.backgroundColor = UIColor(named: "SecondaryColor")
            dinnerButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if lunchPressed && !dinnerPressed {
            currentMenu.availableRecipesTime = 0
        } else if !lunchPressed && dinnerPressed {
            currentMenu.availableRecipesTime = 1
        } else {
            currentMenu.availableRecipesTime = 2
        }
        
        if !lunchPressed && !dinnerPressed {
            nextButton.alpha = 0.25
        } else {
            nextButton.alpha = 1
        }
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
