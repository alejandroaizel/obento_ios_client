//
//  RecipeDAO.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

class RecipeDAO {
    func createRecipe(_ recipe: Recipe) {
        let PATH: String = "/recipes"
        
        // Preparamos la receta
        var ingredientList: [[String:Int]] = []
        for ing in recipe.ingredients {
            ingredientList.append([
                "ingredient_id": ing.id,
                "quantity": ing.quantity!
            ])
        }
        
        let json: [String: Any] = ["name": recipe.name,
                                   "description": recipe.description,
                                   "category": recipe.typeInt ?? 1, // TODO: ARREGLAR
                                   "steps": recipe.steps,
                                   "is_lunch": recipe.isLaunch,
                                   "image_path": recipe.imagePath,
                                   "cooking_time": recipe.time,
                                   "servings": recipe.servings,
                                   "user": 1, // recipe.userId, TODO: CAMBIAR
                                   "ingredients": ingredientList
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
}


