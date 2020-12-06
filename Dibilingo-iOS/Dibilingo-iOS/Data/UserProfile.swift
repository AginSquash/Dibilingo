//
//  UserProfile.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 11.10.2020.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    var lastUpdated: String
    var name: String
    var coins: Int
    var coinsInCategories: [String:Int]
    
    static func < (lhs: UserProfile, rhs: UserProfile) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date1 = dateFormatter.date(from: lhs.lastUpdated) else { fatalError("date1 is nil") }
        guard let date2 = dateFormatter.date(from: rhs.lastUpdated) else { fatalError("date2 is nil") }
        
        print(date1)
        print(date2)
        
        return date1 < date2
    }
}
