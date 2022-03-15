//
//  RecipeViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

class RecipeViewController: UIViewController {
    @IBOutlet weak var yamadaButton: UIButton!
    
    var recipeInformation: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(recipeInformation.name)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func yamadaAction(_ sender: Any) {
        yamada()
    }
    
}
