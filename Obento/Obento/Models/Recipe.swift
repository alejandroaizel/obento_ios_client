//
//  RecipeInformation.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

struct Recipe {
    var id: Int
    var userId: Int
    var name: String
    var description: String
    var puntuaction: Double
    var kcal: Int
    var time: Int
    var price: Double
    var isLaunch: Bool
    var imagePath: String
    var type: String
    var servings: Int
    var ingredients: [Ingredient]
    var steps: [String]
}
