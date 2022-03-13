//
//  RecipeInformation.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 11/3/22.
//

import UIKit

struct Recipe {
    let id: Int
    let userId: Int
    let name: String
    let description: String
    let puntuaction: Double
    let kcal: Int
    let time: Int
    let price: Double
    let isLaunch: Bool
    let imagePath: String
    let ingredients: [Ingredient]
    let steps: [String]
}
