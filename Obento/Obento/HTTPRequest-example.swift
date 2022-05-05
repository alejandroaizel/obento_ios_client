//
//  ola.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 13/3/22.
//

import UIKit

func callExample() {
    var ingredientList: [Ingredient] = []
    
    var request = URLRequest(url: URL(string: "http://13.37.225.162:8000/ingredients")!)

    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let session = URLSession.shared

    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        // print(response!)
        do {
            let dict = try JSONSerialization.jsonObject(with: data!)  as! [Dictionary<String, AnyObject>]
            
            for ingredient in dict {
                ingredientList.append(Ingredient(id: ingredient["id"] as! Int, name: ingredient["name"]! as! String, category: ingredient["category"] as! String, unitaryPrice: ingredient["unitary_price"] as! Double, unit: ingredient["unit"] as! String, kcal: ingredient["kcalories"] as! Double, iconPath: ingredient["icon_name"] as! String))
            }
        } catch {
            print("error")
        }
    })

    task.resume()
    
    // return ingredientList
}
