//
//  RecipeInformation.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

struct Recipe: Codable {

    var id: Int
    var name: String
    var description: String
    var category: String
    var steps: [String]
    var cookingTime: Int
    var isLunch: Bool
    var image: Data
    var servings: Int
    var userId: Int
    var kcalories: Float
    var estimatedCost: Float
    var ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case steps
        case cookingTime = "cooking_time"
        case isLunch = "is_lunch"
        case imagePath = "image_path"
        case servings
        case userId = "user"
        case kcalories
        case estimatedCost = "estimated_cost"
        case ingredients
    }
    
    /*
    init(
        id: Int,
        name: String,
        description: String,
        category: String,
        steps: [String],
        cookingTime: Int,
        isLunch: Bool,
        imagePath: String,
        servings: Int,
        userId: Int,
        ingredients: [Ingredient]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.steps = steps
        self.cookingTime = cookingTime
        self.isLunch = isLunch
        self.imagePath = imagePath
        self.servings = servings
        self.userId = userId
        self.ingredients = ingredients
    }
    */

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        category = try values.decode(String.self, forKey: .category)
        steps = try values.decode([String].self, forKey: .steps)
        cookingTime = try values.decode(Int.self, forKey: .cookingTime)
        isLunch = try values.decode(Bool.self, forKey: .isLunch)
        image = Recipe.getImageData(imageURL: try! values.decode(
                String.self,
                forKey: .imagePath)
        )!
        servings = try values.decode(Int.self, forKey: .servings)
        userId = try values.decode(Int.self, forKey: .userId)
        kcalories = try values.decode(Float.self, forKey: .kcalories)
        estimatedCost = try values.decode(Float.self, forKey: .estimatedCost)
        ingredients = try values.decode([Ingredient].self, forKey: .ingredients)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(parseCategory(), forKey: .category)
        try container.encode(steps, forKey: .steps)
        try container.encode(cookingTime, forKey: .cookingTime)
        try container.encode(isLunch, forKey: .isLunch)
        try container.encode(image, forKey: .imagePath)
        try container.encode(servings, forKey: .servings)
        try container.encode(userId, forKey: .userId)
        try container.encode(ingredients, forKey: .ingredients)
    }

    func parseCategory() -> Int {
        switch category {
        case "Arroces":
            return 1
        case "Bocadillos y Hamburguesas":
            return 2
        case "Carnes":
            return 3
        case "Ensaladas y Bowls":
            return 4
        case "Guisos":
            return 5
        case "Legumbres":
            return 6
        case "Pastas":
            return 7
        case "Pescado y marisco":
            return 8
        case "Salteado":
            return 9
        case "Sandwich":
            return 10
        case "Sopas y crema":
            return 11
        case "Verduras y vegetales":
            return 12
        default:
            return 0
        }
    }
    
    static func getImageData(imageURL: String) -> Data? {
        let dataurl: String = "http://13.37.225.162:8000" + imageURL
        let url = URL(string: dataurl)
        let data = try? Data(contentsOf: url!)
        return data
    }
}

