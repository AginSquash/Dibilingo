//
//  SentenceJSON.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 15.12.2020.
//

import Foundation

struct SentenceJSON: Codable {
    let sentence: String
    
    init (_ sentence: String) {
        self.sentence = sentence
    }
}
