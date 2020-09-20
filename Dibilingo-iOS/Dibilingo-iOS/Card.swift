//
//  Card.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import Foundation

struct Card: Codable {
    let emoji: String
    let object_name: String
    let real_name: String
    
    static func getExamples() -> [Card] {
        return [Card(emoji: "🐺", object_name: "wolf", real_name: "wolf"), Card(emoji: "🐺", object_name: "wolf", real_name: "wolf"), Card(emoji: "🐺", object_name: "wolf", real_name: "wolf")]
    }
}
