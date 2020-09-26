//
//  Card.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import Foundation
import SwiftUI

struct Card {
    
    let image: Image
    let object_name: String
    let real_name: String
    
    /*
    static func getExamples() -> [Card] {
        return [Card(object_name: "wolf", real_name: "wolf"), Card(object_name: "mouse", real_name: "mouse"), Card(object_name: "wolf", real_name: "hamster")]
    }
     */
    
}
 

struct CardList_server: Codable {
    var cards: [String] = []
}

struct CardList: Codable {
    var new_cards: [String] = []
    var answered_cards: [String] = []
    
    init(cl_s: CardList_server) {
        self.new_cards = cl_s.cards
    }
    
    init() {
        self.new_cards = []
        self.answered_cards = []
    }
}
