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
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        
        let bottomSpace: CGFloat = 5.0
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
    }*/
    
}
