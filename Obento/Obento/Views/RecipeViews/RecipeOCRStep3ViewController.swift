//
//  RecipeOSRStep3ViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 20/3/22.
//

import UIKit

class RecipeOCRStep3ViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var button: UIButton!
    var currentRecipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhotoButton(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension RecipeOCRStep3ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
        UIImage else {
            return
        }
        Task {
//            let b64_data = image.pngData()
//            let ocrData: OCRData = await ObentoApi.postRecipeOCR(
//                imageData: b64_data
//            )!
//
//            self.currentRecipe.steps = ocrData.steps
//            self.currentRecipe.ingredients = ocrData.ingredients
            
            self.currentRecipe = await ObentoApi.getRecipe(id: 98)
            
            let vc = storyboard?.instantiateViewController(
                withIdentifier: "RecipeCommonStep5ViewController"
            ) as! RecipeCommonStep5ViewController
            
            vc.currentRecipe = self.currentRecipe

            self.navigationController?.pushViewController (vc, animated: true)
            
        }
        
    }
}
