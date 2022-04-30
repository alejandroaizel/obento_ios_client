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
    
    var shoppingList: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let newItems = await ObentoApi.getIngredients()
            
            self.shoppingList = newItems
            
            NotificationCenter.default.addObserver(self, selector: #selector(notified(_:)), name: NSNotification.Name(rawValue: "updateCartTableView"), object: nil)
            
            registerCells()
            cartTableView.reloadData()
        }
    }
    
    @objc func notified(_ notification : Notification)  {
        Task {
            let newItems = await ObentoApi.getIngredients()
            
            self.shoppingList = newItems
        }
        
        self.cartTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func registerCells() {
        cartTableView.register(UINib(nibName: CartTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CartTableViewCell.identifier)
    }
    
    func addNewItems(_ newItems: [Ingredient]) {
        shoppingList.append(contentsOf: newItems)
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
