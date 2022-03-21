//
//  Menu.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

struct Menu {
    var numDays: Int
    var startDay: CustomDay
    var endDay: CustomDay
    var maxTime: Int?
    var maxPrice: Int?
    var availableRecipesTime: Int?
    var bannedIngredients: [Ingredient]?
    var recipes: [Recipe]
}
