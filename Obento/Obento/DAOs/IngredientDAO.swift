//
//  IngredientDAO.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

let HOST = "http://13.37.225.162:8000"

class IngredientDAO {
    var ingredientList: [Ingredient] = []
    
    func getAllIngredients() -> [Ingredient] {
        var request = URLRequest(url: URL(string: HOST + "/ingredients")!)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: [Ingredient] = []
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let dict = try JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
                
                for ingredient in dict {
                    result.append(Ingredient(id: ingredient["id"] as! Int, name: ingredient["name"]! as! String, category: ingredient["category"] as! String, unitaryPrice: ingredient["unitary_price"] as! Double, unit: ingredient["unit"] as! String, kcal: ingredient["kcalories"] as! Double, iconPath: "ing_carrot")) //ingredient["icon_name"] as! String))
                }
                
                semaphore.signal()
            } catch {
                print("error")
            }
        })
        
        task.resume()
        semaphore.wait()
        
        return result
    }
}
