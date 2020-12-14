//
//  utilities.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import Foundation
import SwiftUI


//EXTENSIONS

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
            
        }
        
        //print("COLOR: \(Double(r)/255), \(Double(g)/255), \(Double(b)/255), \(Double(a)/255)")

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


extension Array where Element == String {
    func combineToString() -> String {
        
        if self.count == 0 { return "" }
        
        var combined = String()
        for element in self {
            combined += element
            combined += " "
        }
        combined.removeLast()
        return combined
    }
}


func getUserProfile() -> UserProfile? {
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    if let up_data = try? Data(contentsOf: baseURL.appendingPathComponent("UserProfile")) {
        if let up_decoded = try? JSONDecoder().decode(UserProfile.self, from: up_data) {
            return up_decoded
        }
    }
    return nil
}

func saveUserProfile(_ up: UserProfile) {
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    if let encoded = try? JSONEncoder().encode(up) {
        try? encoded.write(to: baseURL.appendingPathComponent("UserProfile"), options: .atomic)
    }
}
