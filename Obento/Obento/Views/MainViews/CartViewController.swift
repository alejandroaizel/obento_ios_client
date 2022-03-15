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
    
    var shoppingList: [Ingredient] = [
        .init(id: 0, name: "Zanahorias", category: "", unitaryPrice: 0.32, unit: "uds", kcal: 20, iconPath: "ing_carrot", quantity: 3),
        .init(id: 1, name: "Patatas", category: "", unitaryPrice: 0.61, unit: "uds", kcal: 35, iconPath: "ing_carrot", quantity: 10),
        .init(id: 2, name: "Macarrones", category: "", unitaryPrice: 0.002 , unit: "g", kcal: 10, iconPath: "ing_carrot", quantity: 100)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    private func registerCells() {
        cartTableView.register(UINib(nibName: CartTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CartTableViewCell.identifier)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as! CartTableViewCell
        cell.setup(shoppingList[indexPath.row])
        
        return cell
    }
}
