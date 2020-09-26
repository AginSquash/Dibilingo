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
    
    @State var needShowCorrectAnswer: String? = nil
    
    @State private var coins: Int = 0
    var ScoreText: String {
        return "\(coins)/54"
    }
    
    @State private var isPointUp: Bool = false
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            /*
            Rectangle()
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
             */
            Image(decorative: "back_1st")
                .frame(width: 100, height: 100, alignment: .center)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
            
            
            VStack {
                HStack {
                    Spacer()
                    if isPointUp {
                        Image(systemName: "arrow.up.circle")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.green)
                            .transition(.opacity)
                    }
                    Text("\(coins)/54")
                        .foregroundColor(.white)
                        .font(Font.custom("Coiny", size: 38))
                        .padding(.trailing)
                }
                Spacer()
            }
            .zIndex(2)
            
            VStack {
                Spacer()
                    .frame(width: 100, height: 150, alignment: .center)
                if currentCard != nil {
                    CardView(card: currentCard!, removal: self.checkAnswer, feedback: feedback )
                        .offset(y: self.offset ?? 0)
                        .allowsHitTesting(needShowCorrectAnswer == nil ? true : false)
                        .transition(.scale)
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
        //check for correct answer
        if ((currentCard?.object_name == currentCard?.real_name) && rightSwipe) || (currentCard?.object_name != currentCard?.real_name) && !rightSwipe {
            withAnimation(.easeIn(duration: 0.5), { isPointUp = true })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {  self.coins += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.5), { isPointUp = false })
            }
        } else {
            withAnimation {
                needShowCorrectAnswer = currentCard?.real_name
                feedback.notificationOccurred(.error)
            }
        }
        
    
        nextCard()
    }
    
    func nextCard() {
        guard let cards = cards else { return }
        guard cards.count > 0 else { return }
        self.cards?.remove(at: 0)
        
        currentCard = cards[0]
        
    }
    
}

struct EmojiWordView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiWordView()
    }
}
