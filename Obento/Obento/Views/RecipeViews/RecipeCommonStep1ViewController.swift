//
//  RecipeCommonStep1ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit
import PhotosUI

class RecipeCommonStep1ViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    var currentRecipe: Recipe?
    var currentImage: UIImage?
    var categories: [String] = []
    var currentCategory: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minusServing.alpha = 0.3

        // Get categories
        Task {
            categories = await ObentoApi.getRecipeCategories()
        }
        
        self.addDoneButtonOnKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        nameImput.setLeftPaddingPoints(10)
        nameImput.setRightPaddingPoints(40)
        
        descriptionInput.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

        registerCells()
        // Do any additional setup after loading the view.
    }
    
    private func registerCells() {
        categoriesCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
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

        nameImput.inputAccessoryView = doneToolbar
        descriptionInput.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            nameImput.resignFirstResponder()
            descriptionInput.resignFirstResponder()
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
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameImput.resignFirstResponder()
        descriptionInput.resignFirstResponder()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }*/

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
        
        currentRecipe?.isLunch = true
    }
    
    @IBAction func dinnerToggleAction(_ sender: Any) {
        lunchToggleButton.backgroundColor = UIColor(named: "clearColor")
        lunchToggleButton.tintColor = UIColor(named: "PrimaryColor")
        lunchToggleButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
        
        dinnerToggleButton.backgroundColor = UIColor(named: "ObentoGreen")
        dinnerToggleButton.tintColor = .white
        dinnerToggleButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        
        currentRecipe?.isLunch = false
    }

    @IBAction func reduceServingAction(_ sender: Any) {
        plusServing.alpha = 1
        
        if currentRecipe?.servings ?? 1 > 1 {
            currentRecipe?.servings -= 1
            
            if currentRecipe?.servings == 1 {
                minusServing.alpha = 0.3
                servingLabel.text = "1 ración"
                
                return
            }
            
            servingLabel.text = "\(currentRecipe?.servings ?? 1) raciones"
        }
    }
    
    @IBAction func addServingAction(_ sender: Any) {
        minusServing.alpha = 1
        
        if currentRecipe?.servings ?? 1 < 9 {
            currentRecipe?.servings += 1
            
            if currentRecipe?.servings == 9 {
                plusServing.alpha = 0.3
            }
            
            servingLabel.text = "\(currentRecipe?.servings ?? 1) raciones"
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
        currentRecipe?.name = nameImput.text ?? "" // TODO: no permitir
        currentRecipe?.description = descriptionInput.text ?? ""
        currentRecipe?.imagePath = "recipe_1" // TODO: Subir imagen y guardar el id currentImage
        currentRecipe?.cookingTime = Int(timePicker.countDownDuration / 60)
        currentRecipe?.category = categories[currentCategory]
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
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

extension RecipeCommonStep1ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.setup(categories[indexPath.row])
        cell.tag = indexPath.row
        
        if indexPath.row == currentCategory {
            cell.categoryLabel.textColor = .white
            cell.categoryView.backgroundColor = UIColor(named: "ObentoGreen")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var i: Int = 1;
        for indexPath in categoriesCollectionView.indexPathsForVisibleItems {
            let cell = categoriesCollectionView.cellForItem(at: indexPath)
            
            if cell?.tag == indexPath.row {
                (cell as! CategoryCollectionViewCell).categoryView.backgroundColor = UIColor.init(named: "ObentoGreen")
                (cell as! CategoryCollectionViewCell).categoryLabel.textColor = .white
                
                currentCategory = indexPath.row
                
                continue
            }
            
            (cell as! CategoryCollectionViewCell).categoryView.backgroundColor = UIColor.init(named: "SecondaryColor")
            (cell as! CategoryCollectionViewCell).categoryLabel.textColor = UIColor.init(named: "TextColor")
            
            i += 1
        }
    }
}
