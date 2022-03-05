//
//  AddViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 5/3/22.
//

import UIKit

/// The view controller for the add recipe tab
class AddViewController: UIViewController {
    @IBOutlet weak var CloseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// This function closes the current view
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
