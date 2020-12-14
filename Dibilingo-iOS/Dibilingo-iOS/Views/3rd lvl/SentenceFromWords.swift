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
    @State private var rows = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // sorted words little-big-little

    var words_paired: [identifiable_word] {
        var words_sorted = words.sorted(by: { $0.text.count < $1.text.count })
        
        var words = [identifiable_word]()
        
        while words_sorted.count != 0 {
            let w1 = words_sorted.removeFirst()
            words.append(w1)
            guard words_sorted.count > 0 else {
                break
            }
            let w2 = words_sorted.removeLast()
            words.append(w2)
            
            guard words_sorted.count > 0 else {
                break
            }
            let w3 = words_sorted.removeFirst()
            words.append(w3)
        }
        
        
        
        return words //.shuffled()
    }
    
    var body: some View {
        ZStack {
            VStack {
                //Text(sentence)
                
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                LazyVGrid(columns: columns) {
                
                //LazyHGrid(rows: rows) {
                    ForEach(words_paired) { word in
                        Text(word.text)
                    }
                }.frame(height: 100, alignment: .center)
                
            }
        }
        .onAppear(perform: {
            self.words.append(identifiable_word("long_woord"))
            self.words.append(identifiable_word("word"))
            self.words.append(identifiable_word("wordkdkkaka"))
            self.words.append(identifiable_word("words"))
            self.words.append(identifiable_word("a"))
            self.words.append(identifiable_word("wordaapppa"))
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
