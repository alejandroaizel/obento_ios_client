//
//  RecipeCategory.swift
//  Obento
//
//  Created by Víctor Palma on 2/4/22.
//

import Foundation

struct RecipeCategory: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
    }
}
