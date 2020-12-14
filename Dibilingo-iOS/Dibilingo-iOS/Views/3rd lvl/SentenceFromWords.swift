//
//  SentenceFromWords.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 07.12.2020.
//

import SwiftUI

struct SentenceFromWords: View {
    
    @State private var sentence: String = "The hyperdrive would've split on impact."
    @State private var words = [identifiable_word]()
    @State private var entered_sentence = [identifiable_word]()
    @State private var correct_array = [identifiable_word]()
    
    @State private var showCorrectAnswer: String? = nil
    
    var body: some View {
        ZStack {
            
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text(entered_sentence.combineToString())
                    .foregroundColor(.black)
                    .font(Font.custom("boomboom", size: 30))
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .trailing])
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
                
                if entered_sentence.count != 0 {
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
                            .frame(width: 30, height: 30, alignment: .center)
                    })
                    .transition(.scale)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                WordView(words: $words) { word in
                    if self.entered_sentence.contains(where: { $0.id == word.id }) { return }
                    
                    withAnimation {
                        entered_sentence.append(word)
                    }
                    
                    if words.count == 0 {
                        if isCorrect() {
                            print("Yeah!")
                        } else {
                            withAnimation {
                                self.showCorrectAnswer = "\"\(correct_array.combineToString())\""
                            }
                        }
                    }
                }
                .padding()
            }
            
            
            if showCorrectAnswer != nil {
                EW_Overlay(needCorrectAnswer: $showCorrectAnswer, customView: true, showCorrectAnswerLabel: true)
                    .zIndex(3)
                    .transition(.slide)
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            /*
            words.append(identifiable_word("long_woord"))
            words.append(identifiable_word("word"))
            words.append(identifiable_word("wordkdkkaka"))
            words.append(identifiable_word("words"))
            words.append(identifiable_word("a"))
            words.append(identifiable_word("wordaapppa")) */
            calculateAppear()
        })
    }
    
    func calculateAppear() {
        var newSentence = self.sentence.lowercased()
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
        SentenceFromWords()
    }
}
