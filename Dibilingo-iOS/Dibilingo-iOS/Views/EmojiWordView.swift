//
//  EmojiWordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EmojiWordView: View {
    
    @State private var cards: [Card] = Card.getExamples()
    
    var body: some View {
        ZStack {
            VStack {
                CardView(card: cards.first ?? Card(emoji: "nil", object_name: "nil", real_name: "nil"))
            }
        }
    }
}

struct EmojiWordView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiWordView()
    }
}
