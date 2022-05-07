//
//  WeeklyMenu.swift
//  Obento
//
//  Created by Víctor Palma on 1/5/22.
//
//
import Foundation

struct WeeklyMenu: Codable {
    
    let dateController: DateController = DateController()
    
    var user: Int
    var startDate: Date
    var endDate: Date
    var menuItems: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case user = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case menuItems = "recipes"
    }
    
    init(userId: Int, items: [MenuItem]) {
        user = userId
        menuItems = items
        startDate = Date(timeIntervalSince1970: 0)
        endDate = Date(timeIntervalSince1970: 0)
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decode(Int.self, forKey: .user)
        startDate = try values.decode(Date.self, forKey: .startDate)
        endDate = try values.decode(Date.self, forKey: .endDate)
        menuItems = try values.decode([MenuItem].self, forKey: .menuItems)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode([menuItems].self, forKey: .menuItems)
    }
}
