//
//  MenuDAO.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

class MenuDAO {
    func createMenu(_ menu: Menu) {
        let PATH: String = "/menus"
        
        let date: String = String(menu.startDay.day) + "-" + String(menu.startDay.month) + "-" + String(menu.startDay.year).suffix(2) + "|" + String(menu.endDay.day) + "-" + String(menu.endDay.month) + "-" + String(menu.endDay.year).suffix(2)
        
        // Preparamos el menú
        let json: [String: Any] = ["user": 1, // TODO: CAMBIAR ESTO
                                   "date": date,
                                   ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let JSONString = String(data: jsonData!, encoding: String.Encoding.utf8) {
           print(JSONString)
        }
        
        var request = URLRequest(url: URL(string: HOST + PATH)!)

        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                // _ = try JSONSerialization.jsonObject(with: data!)  as! [Dictionary<String, AnyObject>]
                
                print("ola")
                
                //semaphore.signal()
            } catch {
                print("error")
            }
        })
        
        task.resume()
        // semaphore.wait()
    }
    
    func getMenu(from userID: Int, on date: CustomDay, isLunch lunch: Bool) -> Recipe {
        let PATH: String = "/menus" // TODO: CAMBIAR
        
        let date: String = String(date.day) + "-" + String(date.month) + "-" + String(date.year).suffix(2)
        
        var request = URLRequest(url: URL(string: HOST + PATH)!)
        
        let json: [String: Any] = ["user": 1, // TODO: CAMBIAR ESTO
                                   "date": date,
                                   "is_lunch": lunch,
                                    ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpMethod = "GET"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        
        var result: Recipe!
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let dict = try JSONSerialization.jsonObject(with: data!)  as! [Dictionary<String, AnyObject>]
                
                for recipe in dict {
                    var ingredients: [Ingredient] = []
                    
                    for ingredient in recipe["ingredients"] as! [Dictionary<String, AnyObject>]{
                        ingredients.append(Ingredient(id: ingredient["id"] as! Int, name: ingredient["name"]! as! String, category: ingredient["category"] as! String, unitaryPrice: ingredient["unitary_price"] as! Double, unit: ingredient["unit"] as! String, kcal: ingredient["kcalories"] as! Double, iconPath: "ing_carrot")) //ingredient["icon_name"] as! String))
                    }
                    
                    result = .init(id: recipe["id"] as! Int, userId: recipe["user"] as! Int, name: recipe["name"] as! String, description: recipe["description"] as! String, puntuaction: recipe["num_stars"] as! Double, kcal: recipe["kcalories"] as! Int, time: recipe["cooking_time"] as! Int, price: recipe["estimated_cost"] as! Double , isLaunch: recipe["is_lunch"] as! Bool, imagePath: recipe["image_path"] as! String, servings: recipe["servings"] as! Int, ingredients: ingredients, steps: recipe["steps"] as! [String])
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
