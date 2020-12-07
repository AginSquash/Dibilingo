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
    
    var body: some View {
        ZStack {
            VStack {
                //Text(sentence)
                
                LazyHGrid(rows: rows) {
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                    Text("12345")
                }.frame(height: 100, alignment: .center)
                
            }
        }
    }
    
    func calculateAppear() {
        
    }
}

struct SentenceFromWords_Previews: PreviewProvider {
    static var previews: some View {
        SentenceFromWords()
    }
}
