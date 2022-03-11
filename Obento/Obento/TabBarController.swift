//
//  TabBarController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 5/3/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    let addButton = UIButton.init(type: .custom)
    
    /// This function loads the tab bar and places one button in the middle to load the add recipe view
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.frame = CGRect (x: 100, y: 0, width: 44, height: 44)
        addButton.addTarget(self, action: #selector(handlePresentingVC(_:)), for: .touchUpInside)
        self.view.insertSubview(addButton, aboveSubview: self.tabBar)

        if (UserDefaults.standard.bool(forKey: "notFirstInApp") == false){
            UserDefaults.standard.set(true, forKey: "notFirstInApp")
            //Here you can show storyboard that you have to launch at first launch
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addButton.frame = CGRect.init(x: self.tabBar.center.x - 45, y: self.view.bounds.height - 83, width: 90, height: 90)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handlePresentingVC(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController

        present(vc, animated: true, completion: nil)
    }
}
