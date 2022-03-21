//
//  MenuCustomStep3ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class MenuCustomStep3ViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    var currentMenu: Menu!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
