//
//  Ingredient.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

struct Ingredient {
    var id: Int
    var name: String
    var category: String
    var unitaryPrice: Double
    var unit: String
    var kcal: Int
    var iconPath: String
    var quantity: Int? // Only for shopping list
}
