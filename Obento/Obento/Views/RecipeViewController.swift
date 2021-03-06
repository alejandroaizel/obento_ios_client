//
//  RecipeViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit
import UserNotifications

class RecipeViewController: UIViewController {
    // Buttons
    @IBOutlet weak var closeViewButton: UIButton!
    @IBOutlet weak var firstStarButton: UIButton!
    @IBOutlet weak var secondStarButton: UIButton!
    @IBOutlet weak var thirdStartButton: UIButton!
    @IBOutlet weak var fourthStartButton: UIButton!
    @IBOutlet weak var fifthStarButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    
    // Recipe Elements
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeType: UILabel!
    @IBOutlet weak var recipePuntuation: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeKcal: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipePrice: UILabel!
    
    // Recipe Ingredients and Steps
    @IBOutlet weak var stepsTableView: UITableView!
    @IBOutlet weak var ingredientsCollection: UICollectionView!
    
    // Others
    var recipeInformation: Recipe?
    var recipeStars: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecipeInformation()
        registerCells()

    }
    
    private func registerCells() {
        ingredientsCollection.register(
            UINib(nibName: IngredientCollectionViewCell.identifier,
                  bundle: nil
                 ),
            forCellWithReuseIdentifier: IngredientCollectionViewCell.identifier
        )
        stepsTableView.register(
            UINib(nibName: StepTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: StepTableViewCell.identifier
        )
    }
    
    func loadRecipeInformation() {
        recipeStars = recipeInformation?.starts ?? 0
        recipeImage.image = UIImage(data: recipeInformation!.image)
        recipeName.text = recipeInformation?.name ?? ""
        recipeType.text = recipeInformation?.category ?? ""
        recipePuntuation.text = "\(recipeStars)"
        recipeDescription.text = recipeInformation?.description ?? ""
        recipeKcal.text = "\(recipeInformation?.kcalories.rounded().clean ?? "0") kcal"
        recipeTime.text = String(recipeInformation?.cookingTime ?? 0) + " min"
        recipePrice.text = String(recipeInformation?.estimatedCost ?? 0) + " ???"
        colorStars(numStars: recipeStars)
        let currentRecipesAdded = UserDefaults.standard.object(forKey: "addedToCart") as? [Int] ?? []
    }
    
    // Buton functions
    @IBAction func closeViewButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fisrtStartClickAction(_ sender: Any) {
        colorStars(numStars: 1)
    }
    
    @IBAction func secondStarClickAction(_ sender: Any) {
        colorStars(numStars: 2)
    }
    
    @IBAction func thirdStarClickAction(_ sender: Any) {
        colorStars(numStars: 3)
    }

    @IBAction func fourthStarClickAction(_ sender: Any) {
        colorStars(numStars: 4)
    }
    
    @IBAction func fifthStarClickAction(_ sender: Any) {
        colorStars(numStars: 5)
    }
    
    @IBAction func addCartAction(_ sender: Any) {
        Task {
            await ObentoApi.updateShoppingListByRecipe(
                userId: 1,
                recipeId: recipeInformation!.id
            )

            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "updateCartTableView"),
                object: recipeInformation!.ingredients
            )
            
            var currentRecipesAdded = UserDefaults.standard.object(
                forKey: "addedToCart"
            ) as? [Int] ?? []
            
            if !currentRecipesAdded.contains(recipeInformation!.id) {
                currentRecipesAdded.append(recipeInformation?.id ?? 0)
                
                UserDefaults.standard.set(
                    currentRecipesAdded, forKey: "addedToCart"
                )
            }
            addCartButton.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
            
            // Notification
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Lista de la compra actualizada"
            content.body = "??Se vienen cosas buenas! Se ha actualizado la lista de la compra"
            content.sound = .default
            content.userInfo = ["value": "Data with local notification"]
            let fireDate = Calendar.current.dateComponents(
                [.day, .month, .year, .hour, .minute, .second],
                from: Date().addingTimeInterval(1)
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: fireDate,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: "reminder",
                content: content,
                trigger: trigger
            )
            center.add(request) { (error) in
                if error != nil {
                    print("Error = \(error?.localizedDescription ?? "error local notification")")
                }
            }
            
//            // Create new notifcation content instance
//            let notificationContent = UNMutableNotificationContent()
//
//            // Add the content to the notification content
//            notificationContent.title = "Lista de la compra actualizada"
//            notificationContent.body = "??Se vienen cosas buenas! Se ha actualizado la lista de la compra"
//            notificationContent.sound = UNNotificationSound.default
//
//            // show this notification five seconds from now
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//            // choose a random identifier
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
//
//            // add our notification request
//            try await UNUserNotificationCenter.current().add(request)
        }
    }
    
    func colorStars(numStars: Int) {
        var resetStars = false
        
        if numStars == 1 && recipeStars == 1 {
            firstStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            firstStarButton.tintColor = UIColor(named: "PrimaryColor")
            
            resetStars = true
            recipeStars = 0
        }
        
        if (!resetStars && 1 <= numStars) {
            firstStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            firstStarButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 1
        } else {
            firstStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            firstStarButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 2 <= numStars) {
            secondStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            secondStarButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 2
        } else {
            secondStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            secondStarButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 3 <= numStars) {
            thirdStartButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            thirdStartButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 3
        } else {
            thirdStartButton.setImage(UIImage(systemName: "star"), for: .normal)
            thirdStartButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 4 <= numStars) {
            fourthStartButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fourthStartButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 4
        } else {
            fourthStartButton.setImage(UIImage(systemName: "star"), for: .normal)
            fourthStartButton.tintColor = UIColor(named: "PrimaryColor")
        }
        
        if (!resetStars && 5 <= numStars) {
            fifthStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fifthStarButton.tintColor = UIColor(named: "StarColor")
            
            recipeStars = 5
        } else {
            fifthStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            fifthStarButton.tintColor = UIColor(named: "PrimaryColor")
        }
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeInformation?.ingredients.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.identifier, for: indexPath) as! IngredientCollectionViewCell

        cell.setup((recipeInformation?.ingredients[indexPath.row])!)

        return cell
    }
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recipeInformation?.steps.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stepsTableView.dequeueReusableCell(withIdentifier: StepTableViewCell.identifier) as! StepTableViewCell
        
        cell.setup(Step(number: indexPath.row + 1, description: (recipeInformation?.steps[indexPath.row])!))
        
        return cell
    }
}
