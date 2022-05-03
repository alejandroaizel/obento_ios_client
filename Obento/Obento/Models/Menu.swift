//
//  Menu.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

struct Menu: Codable {
    var numDays: Int
    var startDay: CustomDay
    var endDay: CustomDay
    var maxTime: Int?
    var maxPrice: Int?
    var availableRecipesTime: Int?
    var bannedIngredients: [Ingredient]?
    var recipes: [Recipe]
}

struct MenuSimple: Codable {
    var user: Int
    var date: String
}

struct MenuComplex: Codable {
    var user: Int
    var date: String
    var discarded_ingredients: [Int]
    var max_time: Int
    var max_price: Int
    var is_lunch: Bool
}
