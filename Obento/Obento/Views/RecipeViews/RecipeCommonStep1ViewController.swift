//
//  RecipeCommonStep1ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit
import PhotosUI

class RecipeCommonStep1ViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var nameImput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var minusServing: UIButton!
    @IBOutlet weak var plusServing: UIButton!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var lunchToggleButton: UIButton!
    @IBOutlet weak var dinnerToggleButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var currentRecipe: Recipe = .init(id: -1, userId: -1, name: "", description: "", puntuaction: -1, kcal: -1, time: -1, price: -1, isLaunch: false, imagePath: "", type: "", servings: 1, ingredients: [], steps: [])
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minusServing.alpha = 0.3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        nameImput.setLeftPaddingPoints(10)
        nameImput.setRightPaddingPoints(40)
        
        descriptionInput.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameImput.resignFirstResponder()
        descriptionInput.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lunchToggleAction(_ sender: Any) {
        dinnerToggleButton.backgroundColor = UIColor(named: "clearColor")
        dinnerToggleButton.tintColor = UIColor(named: "PrimaryColor")
        dinnerToggleButton.setImage(UIImage(systemName: "moon"), for: .normal)
        
        lunchToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        lunchToggleButton.tintColor = .white
        lunchToggleButton.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
        
        currentRecipe.isLaunch = true
    }
    
    @IBAction func dinnerToggleAction(_ sender: Any) {
        lunchToggleButton.backgroundColor = UIColor(named: "clearColor")
        lunchToggleButton.tintColor = UIColor(named: "PrimaryColor")
        lunchToggleButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
        
        dinnerToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        dinnerToggleButton.tintColor = .white
        dinnerToggleButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        
        currentRecipe.isLaunch = false
    }

    @IBAction func reduceServingAction(_ sender: Any) {
        plusServing.alpha = 1
        
        if currentRecipe.servings > 1 {
            currentRecipe.servings -= 1
            
            if currentRecipe.servings == 1 {
                minusServing.alpha = 0.3
                servingLabel.text = "1 ración"
                
                return
            }
            
            servingLabel.text = String(currentRecipe.servings) + " raciones"
        }
    }
    
    @IBAction func addServingAction(_ sender: Any) {
        minusServing.alpha = 1
        
        if currentRecipe.servings < 9 {
            currentRecipe.servings += 1
            
            if currentRecipe.servings == 9 {
                plusServing.alpha = 0.3
            }
            
            servingLabel.text = String(currentRecipe.servings) + " raciones"
        }
    }
    
    @IBAction func pickImageAction(_ sender: Any) {
        /*if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }*/
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    
    func storeCurrentData() {
        currentRecipe.name = nameImput.text ?? "" // TODO: no permitir
        currentRecipe.description = descriptionInput.text ?? ""
        // currentRecipe
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecipeCommonStep2ViewController") as! RecipeCommonStep2ViewController
        
        storeCurrentData()
        
        vc.currentRecipe = self.currentRecipe
        
        self.navigationController?.pushViewController (vc, animated: true)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension RecipeCommonStep1ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
        {
            nameImput.resignFirstResponder()
            return true;
        }
}

/*extension RecipeCommonStep1ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: {
            () -> Void
            in
        })

        imagePreview.image = (info[.originalImage] as! UIImage)
        currentImage = info[.originalImage] as? UIImage
    }
}*/


extension RecipeCommonStep1ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results[0].itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {
            (object, error)
            in
            if let imagePicked = object as? UIImage {
                DispatchQueue.main.async {
                    self.imagePreview.image = imagePicked
                    self.currentImage = imagePicked
                }
            }
        })
        
        self.dismiss(animated: true, completion: {
            () -> Void
            in
        })
    }
}
