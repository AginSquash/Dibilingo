//
//  UserProfile.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 11.10.2020.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    var name: String
    var coins: String
    var coinsInCategories: [String:Int]
}
