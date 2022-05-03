//
//  CartViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 5/3/22.
//

import UIKit

/// The view controller for the cart tab
class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var totalButton: UILabel!
    var shoppingList: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.allowsMultipleSelectionDuringEditing = false
        
        Task {
            if let list = await ObentoApi.getShoppingListByUser(userId: 1) {
                self.shoppingList = list.ingredients
            }
            NotificationCenter.default.addObserver(
                self, selector: #selector(notified(_:)),
                name: NSNotification.Name(
                    rawValue: "updateCartTableView"),
                object: nil
            )
            registerCells()
            cartTableView.reloadData()
            updatePrice()
        }
    }
    
    func updatePrice() {
        var currentPrice: Float = 0.0
        
        for ingredient in shoppingList {
            currentPrice += ingredient.quantity! * ingredient.unitaryPrice
        }
        
        totalButton.text = String(format:"%.2f", currentPrice) + " €"
    }
    
    @objc func notified(_ notification : Notification)  {
        Task {
            if let list = await ObentoApi.getShoppingListByUser(userId: 1) {
                self.shoppingList = list.ingredients
                self.cartTableView.reloadData()
                updatePrice()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func registerCells() {
        cartTableView.register(
            UINib(
                nibName: CartTableViewCell.identifier,
                bundle: nil),
            forCellReuseIdentifier: CartTableViewCell.identifier
        )
        cartTableView.delegate = self
        cartTableView.dataSource = self
    }
    
    func addNewItems(_ newItems: [Ingredient]) {
        self.shoppingList.append(contentsOf: newItems)
    }

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as! CartTableViewCell
        cell.setup(self.shoppingList[indexPath.row])
        return cell
    }
    
    // This method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToRemove: Ingredient = self.shoppingList[indexPath.row]
            // remove the item from the data model
            self.shoppingList.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            Task {
                var toRemove = itemToRemove
                toRemove.quantity = 0
                await ObentoApi.updateShoppingListByUser(
                    userId: 1,
                    ingredient: toRemove
                )
                updatePrice()
            }
        } else if editingStyle == .insert {
            cartTableView.reloadData()
            updatePrice()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
    ) -> String? {
        return "Eliminar"
    }
}
