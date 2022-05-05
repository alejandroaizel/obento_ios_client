//
//  customDay.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 21/3/22.
//

import Foundation

struct CustomDay: Codable {
    var day: Int
    var month: Int
    var monthString: String
    var year: Int
    
    func toString() -> String {
        return "\(day)-\(month)-\(String(year).suffix(2))"
    }
}
