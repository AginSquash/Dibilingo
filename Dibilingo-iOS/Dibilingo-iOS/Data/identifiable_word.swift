//
//  identifiable_word.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 15.12.2020.
//

import Foundation

struct identifiable_word: Identifiable, Equatable {
    let id: UUID
    let text: String
    
    init (_ text: String) {
        self.id = UUID()
        self.text = text
    }
    
    init (id: UUID, text: String) {
        self.id = id
        self.text = text
    }
    
    
    static func == (lhs: identifiable_word, rhs: identifiable_word ) -> Bool {
        return lhs.text == rhs.text
    }
}
