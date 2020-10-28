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
                            WordView()
                            Image(systemName: "arrow.right")
                                .font(.title)
                            WordView()
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
    
    func onEnded(value: DragGesture.Value, choosenWord: String) {
        
        print("Ok")
        print(choosenWord)
        
        guard let midY = geo?.frame(in: .global).midY else { return }
        if value.location.y > ( midY + 20)  {
            print("OK")
        } else {
            
        }
        
    }
}

struct IrregVerbView_Previews: PreviewProvider {
    static var previews: some View {
        IrregVerbView()
    }
}
