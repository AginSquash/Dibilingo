//
//  UserProfile.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 11.10.2020.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    var lastUpdated: Date
    var name: String
    var coins: Int
    var coinsInCategories: [String:Int]
}
