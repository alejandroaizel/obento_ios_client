//
//  Menu.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

struct MenuItem: Codable {
    
    let dateController: DateController = DateController()
    
    var id: Int
    var user: Int
    var date: Date
    var isLunch: Bool
    var recipe: Recipe
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case date
        case isLunch = "is_lunch"
        case recipe
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        user = try values.decode(Int.self, forKey: .user)
        date = MenuItem.formatDate(
            date: try values.decode(String.self, forKey: .date)
        )
        isLunch = try values.decode(Bool.self, forKey: .isLunch)
        recipe = try values.decode(Recipe.self, forKey: .recipe)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(user, forKey: .user)
        try container.encode(date, forKey: .date)
        try container.encode(isLunch, forKey: .isLunch)
        try container.encode(recipe, forKey: .recipe)
    }
    
    static func getItem(
        menuItems: [MenuItem],
        date: Date,
        isLunch: Bool
    ) -> MenuItem? {
        for menuItem in menuItems {
            if (menuItem.date == date) && (menuItem.isLunch == isLunch) {
                return menuItem
            }
        }
        return nil
    }
    
    static func formatDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: date) ?? Date(timeIntervalSince1970: 0)
    }
}
