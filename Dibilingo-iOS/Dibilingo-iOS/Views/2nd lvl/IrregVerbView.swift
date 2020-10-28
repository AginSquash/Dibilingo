//
//  IrregVerbView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct IrregVerbView: View {
    
    @State private var geo: GeometryProxy?
    @State private var words = ["begin", "begun", "began", "adsd", "forgot", "forgotten", "adaa" ]
    
    @State var wv2 = WordView()
    @State var wv3 = WordView()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //background
                VStack {
                        Spacer()
                        HStack(alignment: .center, spacing: nil) {
                            Spacer()
                            WordView(text: "BEGIN", isBased: true)
                            Image(systemName: "arrow.right")
                                .font(.title)
                            wv2
                            Image(systemName: "arrow.right")
                                .font(.title)
                            wv3
                            Spacer()
                        }
                    
                    Spacer()
                }
                VStack {
                    Spacer()
                    PossibleWordsView(height: geo.size.height/3, onEnded: onEnded, words: words )
                        .padding([.leading, .trailing])
                }
            }
            .onAppear(perform: {
                self.geo = geo
            })
        }
    }
    
    func onEnded(value: DragGesture.Value, choosenWord: String) -> Bool {
        
        print("Ok")
        print(choosenWord)
        
       
        if (value.location.y < 510) && (value.location.y > 450)  {
            
            if value.location.x < 256 {
                if wv2.text != nil { words.append(wv2.text!) }
                wv2.text = choosenWord
            } else {
                if wv3.text != nil { words.append(wv3.text!) }
                wv3.text = choosenWord
            }
            
            withAnimation {
                self.words.removeAll(where: { $0 == choosenWord })
            }
            return true
            
        } else {
            return false
        }
        
    }
}

struct IrregVerbView_Previews: PreviewProvider {
    static var previews: some View {
        IrregVerbView()
    }
}
