//
//  EmojiWordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EmojiWordView: View {
    
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State private var cards: [Card] = []
    @State private var currentCard: Card? = nil
    @State private var offset: CGFloat? = nil
    
    @State var needShowCorrectAnswer: String? = nil
    
    @State private var coins: Int = 0
    var ScoreText: String {
        return "\(coins)/54"
    }
    
    @State private var isPointUp: Bool = false
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var cardList = CardList()
    
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
    
    func getNewCard() -> Card {
        
        var real_name = String()
        if (Int.random(in: 1...4) > 1 && cardList.new_cards.count != 0) || cardList.answered_cards.count == 0 {
             real_name = cardList.new_cards.randomElement()!
        } else {
             real_name = cardList.answered_cards.randomElement()!
        }
        
        var object_name = String()
        if Bool.random() == true {
            object_name = real_name
        } else {
            let totalCards = cardList.answered_cards + cardList.new_cards
            object_name = totalCards.randomElement()!
        }
        
        let image = UIImage(contentsOfFile: baseURL.appendingPathComponent("\(object_name).png").absoluteString)
       
        guard let imageSafe = image else { fatalError("Cannot load \(object_name)") }
        
        return Card(image: Image(uiImage: imageSafe),object_name: object_name, real_name:real_name)
    }
    
    func loadCards() {
        
        /// need update!
        
        // check for end game!
        let data = try? Data(contentsOf: baseURL.appendingPathComponent("CardsList"))
        if let data = data {
            let cardsList = try? JSONDecoder().decode(CardList.self, from: data)
            print(cardsList)
            
            guard let cl = cardsList else { return }
            
            self.cardList = cl
            /*
            let totalCards = cl.answered_cards + cl.new_cards
            
            func generateNewCard(real_name: String) -> Card {
                var object_name = String()
                if Bool.random() == true {
                    object_name = real_name
                } else {
                    let totalCards = cl.answered_cards + cl.new_cards
                    object_name = totalCards.randomElement()!
                }
                let image = UIImage(contentsOfFile: baseURL.appendingPathComponent("\(object_name).png").absoluteString)
               
                guard let imageSafe = image else { fatalError("Cannot load \(object_name)") }
                
                return Card(image: Image(uiImage: imageSafe),object_name: object_name, real_name:real_name)
            }
            
            if (Int.random(in: 1...4) > 1 && cl.new_cards.count != 0) || cl.answered_cards.count == 0 {
                let real_name = cl.new_cards.randomElement()!
                var card = generateNewCard(real_name: real_name)
            } else {
                let real_name = cl.answered_cards.randomElement()!
                var card = generateNewCard(real_name: real_name)
            } */
            
            self.cards.removeAll()
            for _ in 0..<10 {
                self.cards.append(getNewCard())
            }
        }
        
        
        //cards = //Card.getExamples()
        //cards?.append(contentsOf: Card.getExamples())
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
        guard cards.count > 0 else { loadCards(); return }
        self.cards.remove(at: 0)
        
        currentCard = cards[0]
        
    }
    
}

struct EmojiWordView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiWordView()
    }
}
