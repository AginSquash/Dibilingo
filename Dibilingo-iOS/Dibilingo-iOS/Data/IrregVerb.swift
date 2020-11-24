//
//  IrregVerb.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 30.10.2020.
//

import Foundation

struct IrregVerb: Codable {
    let infinitive: String
    let past_simple: String
    let past_participle: String
    
    let other_options: [String]
}

struct words_for_verbs: Identifiable {
    let id = UUID()
    let text: String
}
