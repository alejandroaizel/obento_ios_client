//
//  RecipeCommonStep2ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class RecipeCommonStep2ViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var OCRButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var imageExplanation: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentSelection: Int = 0
    
    var currentRecipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.alpha = 0.4 // TODO: ELIMINAR ESTO CUANDO PONGAMOS OCR
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func OCRAction(_ sender: Any) {
        currentSelection = 0
        
        manualButton.backgroundColor = UIColor(named: "clearColor")
        manualButton.tintColor = UIColor(named: "PrimaryColor")
        
        OCRButton.backgroundColor = UIColor(named: "ObentoGreen")
        OCRButton.tintColor = .white
        
        explanation.text = "Utiliza la cámara de tu teléfono para añadir los ingredientes y los pasos de tu receta de forma automática."
        
        imageExplanation.image = UIImage(named: "new_recipe_illustration_1")
        
        nextButton.alpha = 0.4 // TODO: ELIMINAR ESTO CUANDO PONGAMOS OCR
    }
    
    @IBAction func ManualAction(_ sender: Any) {
        currentSelection = 1
        
        OCRButton.backgroundColor = UIColor(named: "clearColor")
        OCRButton.tintColor = UIColor(named: "PrimaryColor")
        
        manualButton.backgroundColor = UIColor(named: "ObentoGreen")
        manualButton.tintColor = .white
        
        explanation.text = "Si no tienes la receta o prefieres añadirla a mano no te preocupes, con esta opción podrás hacerlo."
        
        imageExplanation.image = UIImage(named: "new_recipe_illustration_2")
        
        nextButton.alpha = 1 // TODO: ELIMINAR ESTO CUANDO PONGAMOS OCR
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if currentSelection == 0 {            
            let vc = storyboard?.instantiateViewController(withIdentifier: "RecipeOCRStep3ViewController") as! RecipeOCRStep3ViewController
            
            vc.currentRecipe = self.currentRecipe
            
            self.navigationController?.pushViewController (vc, animated: true)
        } else if currentSelection == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "RecipeManualStep3ViewController") as! RecipeManualStep3ViewController
            
            vc.currentRecipe = self.currentRecipe
            
            self.navigationController?.pushViewController (vc, animated: true)
        }
        
    }
}
