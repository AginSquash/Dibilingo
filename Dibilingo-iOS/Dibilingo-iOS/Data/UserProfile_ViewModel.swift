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
    @Published var needSaving: Bool = false {
        didSet {
            if needSaving == false {
                guard let up = self.profile else { fatalError("Profile is nil") }
                UserProfile_ViewModel.saveUserProfile(up)
                _uploadToServer()
            }
        }
    }
    
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
    
    func _uploadToServer() {
        guard let up = self.profile else { fatalError("Profile is nil") }
        
        
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
