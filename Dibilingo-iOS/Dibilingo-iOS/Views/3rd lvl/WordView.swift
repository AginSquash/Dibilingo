//
//  WordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 14.12.2020.
//

import SwiftUI

struct WordView: View {
    
    var words: [identifiable_word]
    var onTap: ((String) -> Void)
    
    @State private var words_local = [identifiable_word]()
    
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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            
            LazyVGrid(columns: columns) {
                ForEach(words_local) { word in
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                        Text(word.text)
                            .foregroundColor(.white)
                            .font(Font.custom("boomboom", size: 20))
                            .padding([.top, .bottom])
                    }
                    .onTapGesture {
                        self.onTap(word.text)
                        withAnimation {
                            words_local.removeAll(where: { $0.id == word.id })
                        }
                    }
                }
            }
        }.onAppear(perform: {
            self.words_local = words
        })
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        var words = [identifiable_word]()
        words.append(identifiable_word("long_woord"))
        words.append(identifiable_word("word"))
        words.append(identifiable_word("wordkdkkaka"))
        words.append(identifiable_word("words"))
        words.append(identifiable_word("a"))
        words.append(identifiable_word("wordaapppa"))
        
        words.shuffle()
        
        let onTap: ((String) -> Void) = { word in
            print(word)
        }
        
        return WordView(words: words, onTap: onTap)
    }
}