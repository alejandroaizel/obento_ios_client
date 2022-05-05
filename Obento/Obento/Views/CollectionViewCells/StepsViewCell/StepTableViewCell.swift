//
//  StepTableViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 16/3/22.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    static let identifier = String(describing: StepTableViewCell.self)
    
    @IBOutlet weak var numberViewCell: UILabel!
    @IBOutlet weak var stepDescription: UILabel!
    
    func setup(_ step: Step) {
        numberViewCell.text = String(step.number)
        stepDescription.text = String(step.description)
    }
}
