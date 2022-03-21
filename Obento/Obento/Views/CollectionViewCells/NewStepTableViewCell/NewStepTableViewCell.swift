//
//  NewStepTableViewCell.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class NewStepTableViewCell: UITableViewCell, UITextViewDelegate {
    static let identifier = String(describing: NewStepTableViewCell.self)

    @IBOutlet weak var numStep: UILabel!
    @IBOutlet weak var stepInformation: UITextView!
    
    func setup(_ step: Step) {
        numStep.text = String(step.number)
        stepInformation.text = step.description
        
        self.addDoneButtonOnKeyboard()
        
        stepInformation.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
    func textViShouldReturn(_ textField: UITextView) -> Bool {
        textField.resignFirstResponder()
        
        return (true)
    }
    
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.backgroundColor = .systemBackground

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

        stepInformation.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            stepInformation.resignFirstResponder()
        }
    
    
    var textChanged: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepInformation.delegate = self
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(stepInformation.text)
    }
}
