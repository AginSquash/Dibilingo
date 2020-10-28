//
//  EmojiWordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EmojiWordView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State private var cards: [Card] = []
    @State private var currentCard: Card? = nil
    @State private var offset: CGFloat? = nil
    
    @State private var needShowCorrectAnswer: String? = nil
    
    @State private var coins: Int = 0
    var ScoreText: String {
        return "\(coins)/54"
    }
    
    @State private var isPointUp: Bool = false
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var cardList = CardList()
    
    var debugCard: Card? = nil
    
    var body: some View {
        ZStack {

            Image(decorative: "back_1st")
                .frame(width: 100, height: 100, alignment: .center)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
            
            
            VStack {
                HStack {
                    
                    Text("Go Back")
                        .foregroundColor(.red)
                        .font(Font.custom("boomboom", size: 42))
                        .padding(.leading)
                        .onTapGesture(count: 1, perform: {
                            saveCardList()
                            self.mode.wrappedValue.dismiss()
                        })
                    
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
                        .onTapGesture(count: 2, perform: printCL)
                }
                Spacer()
            }
            .zIndex(2)
            

                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index], isLastCard: index == 0, removal: self.checkAnswer, feedback: feedback )
                            .stacked(at: index, in: cards.count)
                            .offset(y: self.offset ?? 0)
                            .allowsHitTesting(needShowCorrectAnswer == nil ? true : false)
                            .allowsHitTesting(index == cards.count-1)
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
        
        let data = try? Data(contentsOf: baseURL.appendingPathComponent("\(real_name).jpg"))
        guard let dataSafe = data else { fatalError("Cannot load \(real_name)") }
        
        let image = UIImage(data: dataSafe)
        guard let imageSafe = image else { fatalError("Cannot load \(real_name)") }
        
        return Card(image: imageSafe, object_name: object_name, real_name: real_name)
    }
    
    func printCL() {
        print(cardList)
    }
    
    func refreshCards() {
        self.cards.removeAll()
        var newCards: [Card] = []
        for _ in 0..<10 {
            newCards.append(getNewCard())
        }
        withAnimation { self.cards = newCards }
    }
    
    func loadCards() {
        /// need update!
        
        if debugCard != nil {
            //currentCard = debugCard
            cards = [debugCard!, debugCard!, debugCard!, debugCard!, debugCard!, debugCard!]
            return
        }
        
        // check for end game!
        let data = try? Data(contentsOf: baseURL.appendingPathComponent("CardsList"))
        if let data = data {
            print("Data loaded: \(data)")
            let cardsList = try? JSONDecoder().decode(CardList.self, from: data)
            print(cardsList)
            
            guard let cl = cardsList else { return }
            
            self.cardList = cl
            
            refreshCards()
        }
        
        nextCard()
    }
    
    func saveCardList() {
        if let encoded = try? JSONEncoder().encode(cardList) {
            do {
                try encoded.write(to: baseURL.appendingPathComponent("CardsList"))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkAnswer(rightSwipe: Bool) {
        // check for correct answer
        if ((currentCard?.object_name == currentCard?.real_name) && rightSwipe) || (currentCard?.object_name != currentCard?.real_name) && !rightSwipe {
            
            withAnimation(.easeIn(duration: 0.5), { isPointUp = true })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {  self.coins += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.5), { isPointUp = false })
            }
            
            if (currentCard?.object_name == currentCard?.real_name) && rightSwipe {
                guard let card_name = currentCard?.real_name else { fatalError("card_name is nil") }
                
                if cardList.answered_cards.contains(card_name) == false {
                    cardList.new_cards.removeAll(where: { $0 == card_name })
                    cardList.answered_cards.append(card_name)
                }
            }
            
        } else {
            withAnimation {
                needShowCorrectAnswer = currentCard?.real_name
                feedback.notificationOccurred(.error)
            }
        }
        self.cards.remove(at: cards.endIndex-1)
    
        nextCard()
    }
    
    func nextCard() {
        if cards.count < 1 { refreshCards() }
        currentCard = cards[cards.endIndex-1]
        print("current card settup")
    }
    
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}


struct EmojiWordView_Previews: PreviewProvider {
    static var previews: some View {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let data = try? Data(contentsOf: baseURL.appendingPathComponent("wolf.jpg"))
        let image = UIImage(data: data!)!
        let card = Card(image: image, object_name: "wolf", real_name: "wolf")
        
        return EmojiWordView(debugCard: card)
    }
}
