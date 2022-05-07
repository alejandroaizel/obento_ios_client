//
//  ShoppingList.swift
//  Obento
//
//  Created by Víctor Palma on 1/5/22.
//

import Foundation

struct ShoppingList: Codable {
    var totalPrice: Float
    var ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case ingredients
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPrice = try values.decode(Float.self, forKey: .totalPrice)
        ingredients = try values.decode([Ingredient].self, forKey: .ingredients)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalPrice, forKey: .totalPrice)
        try container.encode(ingredients, forKey: .ingredients)
    }
}
