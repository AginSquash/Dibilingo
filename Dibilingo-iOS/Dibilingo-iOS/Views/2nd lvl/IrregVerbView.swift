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
    
    @State var wv2 = WordView(isBased: true)
    @State var wv3 = WordView(isBased: true)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //background
                VStack {
                       // Spacer()
                        //VStack(alignment: .center, spacing: nil) {
                            //Spacer()
                    ZStack {
                            WordView(text: "BEGIN", isBased: true)
                                .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*7) //geo.frame(in: .global).midX
                            //Image(systemName: "arrow.down")
                            //   .font(.headline)
                            //   .position(x: geo.frame(in: .global).midX, y: geo.size.height/16*5.7)
                            wv2
                                .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*9)
                                .transition(.opacity)
                                
                                .onTapGesture(count: 2, perform: {
                                    guard let text = wv2.text else { return }
                                    withAnimation {
                                        self.words.append(text)
                                        wv2.text = nil
                                    }
                                })
                           // Image(systemName: "arrow.right")
                             //   .font(.title)
                            wv3
                                .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*11)
                            //Spacer()
                       // }
                    }
                    
                    //Spacer()
                }
                VStack {
                    Spacer()
                    PossibleWordsView(height: geo.size.height/6*2, onEnded: onEnded, words: words )
                        .padding([.leading, .trailing])
                }
            }
            .onAppear(perform: {
                self.geo = geo
                
                wv2.onLongTap = { text in
                    guard let text = text else { return }
                    withAnimation {
                        self.words.append(text)
                        wv2.text = nil
                    }
                }
                
                wv3.onLongTap = { text in
                    guard let text = text else { return }
                    withAnimation {
                        self.words.append(text)
                        wv3.text = nil
                    }
                }
            })
        }.navigationBarHidden(true)
    }
    
    func onEnded(value: DragGesture.Value, choosenWord: String) -> Bool {
        
        print("Ok")
        print(choosenWord)
        
        guard let geo = self.geo else { return false }
       
        print(geo.frame(in: .global).midX)
        
        if (value.location.x > geo.frame(in: .global).midX - 50) && (value.location.x < geo.frame(in: .global).midX + 50)  {
             
            if value.location.y < geo.size.height/20*7 { return false }
            if value.location.y > geo.size.height/20*13 { return false }
            
            
            if value.location.y < geo.size.height/20*11 {
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
