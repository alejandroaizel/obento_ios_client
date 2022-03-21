//
//  RecipeManualStep4ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class RecipeManualStep4ViewController: UIViewController {
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addStepButton: UIButton!
    @IBOutlet weak var stepsTableView: UITableView!
    
    var currentRecipe: Recipe!
    var currentSteps: [Step] = [Step(number: 1, description: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.alpha = 0.4
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        self.stepsTableView.estimatedRowHeight = 50
        self.stepsTableView.rowHeight = UITableView.automaticDimension
        
        registerCells()

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        stepsTableView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.contentInset.bottom = 0
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    private func registerCells() {
        stepsTableView.register(UINib(nibName: NewStepTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewStepTableViewCell.identifier)
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if currentSteps.count == 0 {
            return
        }
        
        var canContinue: Bool = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecipeCommonStep5ViewController") as! RecipeCommonStep5ViewController
        
        var auxSteps: [String] = []
        
        var i: Int = 1;
        for rowPath in stepsTableView.indexPathsForVisibleRows! {
            let cell = stepsTableView.cellForRow(at: rowPath)
            let cellInformation = (cell as! NewStepTableViewCell).stepInformation.text
            
            if cellInformation == "" {
                continue
            }
            
            canContinue = true
            
            auxSteps.append(cellInformation!)
            
            i += 1
        }
        
        if !canContinue {
            return
        }
        
        currentRecipe.steps = auxSteps
        
        vc.currentRecipe = self.currentRecipe
        
        self.navigationController?.pushViewController (vc, animated: true)
    }
    
    @IBAction func addStepAction(_ sender: Any) {
        var auxSteps: [Step] = []
        var i: Int = 1;
        for rowPath in stepsTableView.indexPathsForVisibleRows! {
            let cell = stepsTableView.cellForRow(at: rowPath)
            
            auxSteps.append(.init(number: i, description: (cell as! NewStepTableViewCell).stepInformation.text!))
            
            i += 1
        }
        
        nextButton.alpha = 1
        
        currentSteps = auxSteps
        
        currentSteps.append(.init(number: currentSteps.count + 1, description: ""))
        
        stepsTableView.reloadData()
    }
    
}

extension RecipeManualStep4ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stepsTableView.dequeueReusableCell(withIdentifier: NewStepTableViewCell.identifier) as! NewStepTableViewCell
        
        cell.setup(currentSteps[indexPath.row])
        cell.tag = indexPath.row
        
        cell.textChanged {[weak stepsTableView] (newText: String) in
            stepsTableView?.beginUpdates()
            stepsTableView?.endUpdates()
        }
        
        return cell
    }
}
