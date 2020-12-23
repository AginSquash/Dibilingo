//
//  UserProfile_ViewModel.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 06.12.2020.
//

import Foundation
import UIKit
import SwiftUI

class UserProfile_ViewModel: ObservableObject {
    @Published var profile: UserProfile? 
    @Published var needSaving: Bool = false
    @Published var onUpdateFinish: ((Int)->Void)?
    
    init() {
        //self.profile = UserProfile_ViewModel.getUserProfile()
    }
    
    func updateUserProfile() {
        self.profile = UserProfile_ViewModel.getUserProfile()
    }
    
    func mainmenuLoad() {
        if profile == nil {
            self.profile = UserProfile_ViewModel.getUserProfile()
        }
    }
    
    func _loadFromServer() {
        
    }
    
    func levelExit() {
        if needSaving {
            _SaveAndUpload()
        }
        needSaving = false
    }
    
    func _SaveAndUpload() {
        guard var up = self.profile else { fatalError("Profile is nil") }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = Date()
        up.lastUpdated = dateFormatter.string(from: date)
        
        // Saving to file
        DispatchQueue.global(qos: .userInitiated).async {
            UserProfile_ViewModel.saveUserProfile(up)
        }
        
        UserProfile_ViewModel.forceUpload(up: up)
        
        guard let updFin = self.onUpdateFinish else { return }
        updFin(getTotalCoins())
    }
    
    static func forceUpload(up: UserProfile) {
        let url = URL(string: "\(serverURL)/dibilingo/api/v1.0/userupdate/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONEncoder().encode(up)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        struct callback: Codable {
            let result: String
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            if let decoded = try? JSONDecoder().decode(callback.self, from: data) {
                print("upload result: \(decoded.result)")
            }
        }
        .resume()
    }
    
    func getTotalCoins() -> Int {
        guard let up = self.profile else { return 0 }
        return UserProfile_ViewModel.getTotalCoinsSTATIC(up: up)
    }
    
    static func getTotalCoinsSTATIC(up: UserProfile) -> Int {
        let categories = [Category(id: 0, name: "animals", locale_name: "Животные", gradient: [""]),
                          Category(id: 1, name: "transport", locale_name: "Транспорт", gradient: ["#f0da4b", "#0d4ea9", "#a4dde0"]),
                          Category(id: 2, name: "weather", locale_name: "Погода", gradient: []),
                          Category(id: 3, name: "random", locale_name: "Рандом", gradient: [] )]
        
        var total_coins: Int = 0
        for category in categories {
            for i in 1...3 {
                total_coins += up.coinsInCategories["\(category.name)_\(i)"] ?? 0
            }
        }
        print("reloaded: \(total_coins)")
        return total_coins
    }
    
    static func getUserProfile() -> UserProfile? {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let up_data = try? Data(contentsOf: baseURL.appendingPathComponent("UserProfile")) {
            if let up_decoded = try? JSONDecoder().decode(UserProfile.self, from: up_data) {
                return up_decoded
            }
        }
        return nil
    }

    static func saveUserProfile(_ up: UserProfile) {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let encoded = try? JSONEncoder().encode(up) {
            try? encoded.write(to: baseURL.appendingPathComponent("UserProfile"), options: .atomic)
        }
    }
}
