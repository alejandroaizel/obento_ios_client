//
//  Ingredient.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

struct Ingredient: Codable {
    var id: Int
    var name: String
    var category: String
    var unitaryPrice: Float
    var unit: String
    var kcalories: Float
    var iconName: String
    var quantity: Float?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ingredientId = "ingredient_id"
        case name
        case category
        case unit
        case unitaryPrice = "unitary_price"
        case kcalories
        case iconName = "icon_name"
        case quantity
    }
    
    init(ingredient_id: Int, ingredient_quantity: Float){
        id = ingredient_id
        quantity = ingredient_quantity
        name = ""
        category = ""
        unitaryPrice = 0.0
        kcalories = 0.0
        iconName = ""
        unit = ""
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // ID key is different between recipes and ingredients resources
        do {
            id = try values.decode(Int.self, forKey: .ingredientId)
        } catch {
            id = try values.decode(Int.self, forKey: .id)
        }
        name = try values.decode(String.self, forKey: .name)
        category = try values.decode(String.self, forKey: .category)
        unit = try values.decode(String.self, forKey: .unit)
        unitaryPrice = try values.decode(Float.self, forKey: .unitaryPrice)
        kcalories = try values.decode(Float.self, forKey: .kcalories)
        iconName = try values.decode(
            String.self,
            forKey: .iconName
        ).replacingOccurrences(of: ".ico", with: "")
        // Quantity is optional
        do {
            quantity = try values.decode(Float.self, forKey: .quantity)
        } catch {
            quantity = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .ingredientId)
        try container.encode(quantity, forKey: .quantity)
    }
    
    
}
