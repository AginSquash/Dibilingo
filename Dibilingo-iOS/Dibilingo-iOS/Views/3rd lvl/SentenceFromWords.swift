//
//  SentenceFromWords.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 07.12.2020.
//

import SwiftUI

struct SentenceFromWords: View {
    
    @State private var sentence: String = "AAA"
    @State private var words = [identifiable_word]()

    @State private var entered_sentence = [String]()
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                Text(entered_sentence.combineToString())
                    .font(Font.custom("boomboom", size: 20))
                    .multilineTextAlignment(.leading)
                    .gesture(
                        DragGesture()
                            .onEnded( { gesture in
                                print(gesture.translation)
                                
                                if entered_sentence.count == 0 { return }
                                
                                if gesture.translation.width < 60 {
                                    let removed = entered_sentence.removeLast()
                                    words.append(identifiable_word(removed))
                                }
                            } )
                    )
                if entered_sentence.count != 0 {
                    Button(action: {
                        
                        withAnimation {
                            words.append(contentsOf: entered_sentence.map({ identifiable_word($0) }))
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
                    withAnimation {
                        entered_sentence.append(word)
                    }
                }
                .padding()
            }
            
        }
        .onAppear(perform: {
            words.append(identifiable_word("long_woord"))
            words.append(identifiable_word("word"))
            words.append(identifiable_word("wordkdkkaka"))
            words.append(identifiable_word("words"))
            words.append(identifiable_word("a"))
            words.append(identifiable_word("wordaapppa"))
        })
    }
    
    func calculateAppear() {
        
    }
}

struct SentenceFromWords_Previews: PreviewProvider {
    static var previews: some View {
        SentenceFromWords()
    }
}
