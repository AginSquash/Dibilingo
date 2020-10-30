//
//  IrregVerbView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct IrregVerbView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var geo: GeometryProxy?
    @State private var words = ["begin", "begun", "began", "adsd", "forgot", "forgotten", "adaa" ]
    
    @State var wv2 = WordView(isBased: true)
    @State var wv3 = WordView(isBased: true)
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //background
                
                VStack {
                    HStack {
                        Text("Go Back")
                            .foregroundColor(.red)
                            .font(Font.custom("boomboom", size: 42))
                            .padding([.leading, .top])
                            .onTapGesture(count: 1, perform: {
                                self.mode.wrappedValue.dismiss()
                            })
                        Spacer()
                    }
                    Spacer()
                }
                
                ZStack {
                        WordView(text: "BEGIN", isBased: true)
                            .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*7)
                        wv2
                            .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*9)
                                
                        wv3
                            .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*11)
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
                    feedback.prepare()
                    guard let text = text else { return }
                    withAnimation {
                        self.words.append(text)
                        wv2.text = nil
                    }
                    self.feedback.notificationOccurred(.error)
                }
                
                wv3.onLongTap = { text in
                    feedback.prepare()
                    guard let text = text else { return }
                    withAnimation {
                        self.words.append(text)
                        wv3.text = nil
                    }
                    self.feedback.notificationOccurred(.error)
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
             
            if value.location.y < geo.size.height/20*9 { return false }
            if value.location.y > geo.size.height/20*13 { return false }
            
            
            if value.location.y < geo.size.height/20*11 {
                withAnimation {
                    if wv2.text != nil { words.append(wv2.text!) }
                    wv2.text = choosenWord
                }
            } else {
                withAnimation {
                    if wv3.text != nil { words.append(wv3.text!) }
                    wv3.text = choosenWord
                }
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
