//
//  EmojiWordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EmojiWordView: View {
    
    @State private var cards: [Card] = Card.getExamples()
    @State private var currentCard: Card? = nil
    @State private var offset: CGFloat? = nil
    
    var body: some View {
        ZStack {
            VStack {
                if currentCard != nil {
                    CardView(card: currentCard!, removal: { withAnimation { self.nextCard() } } )
                        .offset(y: self.offset ?? 0)
                }
            }
        }
        .onAppear(perform: nextCard)
    }
    
    func nextCard() {
        guard cards.count > 0 else { return }
        
        withAnimation(.easeIn(duration: 1.0)) {
            currentCard = nil
            currentCard = cards[0]
           
        }
        cards.remove(at: 0)
    }
    
}

struct EmojiWordView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiWordView()
    }
}
