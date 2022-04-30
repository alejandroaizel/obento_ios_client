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
        
        processMenu()
        rangeDays.text = String(currentMenu.startDay.day) + " " + currentMenu.startDay.monthString.prefix(3).lowercased() + " - " + String(currentMenu.endDay.day) + " " + currentMenu.endDay.monthString.prefix(3).lowercased()
        finalImage.image = UIImage(named: "new_recipe_final_illustration_" + String(Int.random(in: 1...4)))
        
        Task {
            await ObentoApi.postMenu(menu: currentMenu)
        }
    }
    
    func processMenu() {
        
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
