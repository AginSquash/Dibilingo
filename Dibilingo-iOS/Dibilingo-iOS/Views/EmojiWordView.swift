//
//  EmojiWordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EmojiWordView: View {
    
    @State private var cards: [Card]? = nil
    @State private var currentCard: Card? = nil
    @State private var offset: CGFloat? = nil
    
    @State private var coins: Int = 0
    @State var needShowCorrectAnswer: String? = nil
    
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
            
            VStack {
                if currentCard != nil {
                    CardView(card: currentCard!, removal: self.checkAnswer )
                        .offset(y: self.offset ?? 0)
                        .allowsHitTesting(needShowCorrectAnswer == nil ? true : false)
                }
            }
            .zIndex(2)
            
            if needShowCorrectAnswer != nil {
                EW_Overlay(needCorrectAnswer: $needShowCorrectAnswer)
                    .zIndex(3)
                    .transition(.slide)
            }
        }
        .onTapGesture(count: 1, perform: {
            withAnimation {
                needShowCorrectAnswer = nil
            }
        })
        .onAppear(perform: loadCards)
    }
    
    func loadCards() {
        /// need update!
        cards = Card.getExamples()
        cards?.append(contentsOf: Card.getExamples())
        nextCard()
    }
    
    func checkAnswer(rightSwipe: Bool) {
        print(rightSwipe)
        
        //check for correct answer
        if ((cards?[0].object_name == cards?[0].real_name) && rightSwipe) || (cards?[0].object_name != cards?[0].real_name) && !rightSwipe {
            self.coins += 5
        } else {
            withAnimation {
                needShowCorrectAnswer = cards?[0].real_name
            }
        }
        
    
        nextCard()
    }
    
    func nextCard() {
        cards?.remove(at: 0)
        guard let cards = cards else { return }
        guard cards.count > 0 else { return }
        
        currentCard = nil
        currentCard = cards[0]
        
    }
    
}

struct EmojiWordView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiWordView()
    }
}
