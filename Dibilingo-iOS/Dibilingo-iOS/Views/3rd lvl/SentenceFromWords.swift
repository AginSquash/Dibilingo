//
//  SentenceFromWords.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 07.12.2020.
//

import SwiftUI

struct SentenceFromWords: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @ObservedObject var userprofile: UserProfile_ViewModel
    var category_name: String
    var level_name: String {
        "\(category_name)_3"
    }
    
    @State private var words = [identifiable_word]()
    @State private var entered_sentence = [identifiable_word]()
    @State private var correct_array = [identifiable_word]()
    
    @State private var showCorrectAnswer: String? = nil
    
    @State private var sentencesJson = [SentenceJSON]()
    
    @State private var isPointUp: Bool = false
    @State private var coins: Int = 0
    
    var body: some View {
        ZStack {
            
            Image(decorative: "back_3lvl")
                .resizable()
                .scaledToFill()
               // .edgesIgnoringSafeArea(.all)
                .edgesIgnoringSafeArea(.top)
                .zIndex(-1)
            
            VStack {
                Spacer()
                    .frame(width: 10, height: 30, alignment: .center)
                
                HStack {
                    Text("Go Back")
                        .foregroundColor(.red)
                        .font(Font.custom("boomboom", size: 42))
                        .padding(.leading)
                        .onTapGesture {
                            self.mode.wrappedValue.dismiss()
                        }
                    
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
                        .onLongPressGesture {
                            print(getUserProfile())
                        }
                }
                
                Spacer()
                
                if entered_sentence.count != 0 {
                    Text(entered_sentence.combineToString())
                        .foregroundColor(.black)
                        .font(Font.custom("boomboom", size: 30))
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing])
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(minWidth: 75, minHeight: 75)
                                .padding(5)
                                .background(Color.yellow)
                                .cornerRadius(25)
                        )
                        .gesture(
                            DragGesture()
                                .onEnded({ gesture in
                                    if entered_sentence.count == 0 { return }
                                    
                                    if gesture.translation.width < 60 {
                                        withAnimation {
                                            let removed = entered_sentence.removeLast()
                                            words.append(removed)
                                        }
                                    }
                                })
                        )
                        .padding(.bottom, 40)
                
                    Button(action: {
                        
                        withAnimation {
                            words.append(contentsOf: entered_sentence)
                            entered_sentence.removeAll()
                        }
                        
                    }, label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .scaledToFit()
                            .frame(width: 45, height: 45, alignment: .center)
                    })
                    .transition(.scale)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                WordView(words: $words, onTap: wordHandler )
                    .padding()
                    .padding(.bottom)
                    .allowsHitTesting(self.showCorrectAnswer == nil)
            }
            
            
            if showCorrectAnswer != nil {
                EW_Overlay(needCorrectAnswer: $showCorrectAnswer, customView: true, showCorrectAnswerLabel: true)
                    .zIndex(3)
                    .transition(.slide)
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: loadSentences)
        .onDisappear(perform: {
            userprofile.profile?.coinsInCategories[level_name] = self.coins
            userprofile.levelExit()
            
            print("Saved!")
        })
    }
    
    func wordHandler (_ word: identifiable_word) -> Void {
            if self.entered_sentence.contains(where: { $0.id == word.id }) { return }
            
            withAnimation {
                entered_sentence.append(word)
            }
            
            if words.count == 0 {
                if isCorrect() {
                    print("Yeah!")
                    
                    userprofile.needSaving = true
                    withAnimation(.easeIn(duration: 0.5), { isPointUp = true })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {  self.coins += 1 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeIn(duration: 0.5), { isPointUp = false })
                    }
                    
                } else {
                    withAnimation {
                        self.showCorrectAnswer = "\"\(correct_array.combineToString())\""
                    }
                }
                
                /// load next sentence
                withAnimation {
                    self.entered_sentence.removeAll()
                    self.nextSentence()
                }
            }
        
    }
    
    func loadSentences() {
        
        sentencesJson.append(SentenceJSON("I'm watching a movie at the moment"))
        sentencesJson.append(SentenceJSON("Emily is teaching me how to make bread"))
        sentencesJson.append(SentenceJSON("He isn’t listening to the radio now"))
        sentencesJson.append(SentenceJSON("The boats are not moving"))
        sentencesJson.append(SentenceJSON("Are these people waiting for a bus?"))
        sentencesJson.append(SentenceJSON("Am I driving too fast?"))
        
        self.coins = userprofile.profile?.coinsInCategories[level_name] ?? 0
        sentencesJson.shuffle()
        
        nextSentence()
    }
    
    func nextSentence() {
        
        if sentencesJson.count == 0
        {
            print("End")
            return
        }
        
        let id_word = self.sentencesJson.removeFirst()
        var newSentence = id_word.sentence.lowercased()
        newSentence = newSentence.replacingOccurrences(of: ".", with: "")
        let splited = newSentence.split(separator: " ")
        self.correct_array = splited.map({ identifiable_word(String($0)) })
        self.words = correct_array.shuffled()
    }
    
    func isCorrect() -> Bool {
        return entered_sentence == correct_array
    }
}

struct SentenceFromWords_Previews: PreviewProvider {
    static var previews: some View {
        let up = UserProfile_ViewModel()
        return SentenceFromWords(userprofile: up, category_name: "gg")
    }
}
