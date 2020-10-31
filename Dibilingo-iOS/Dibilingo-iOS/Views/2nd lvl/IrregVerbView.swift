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
    @State private var possible_words: [String] = []
    
    @State var p_simpleView = WordView(isBased: true)
    @State var p_participleView = WordView(isBased: true)
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State private var currentVerb: IrregVerb = IrregVerb(infinitive: "begin", past_simple: "began", past_participle: "begun", other_options: ["example", "example"])
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Color(hex: "#3F92D2")
                    .edgesIgnoringSafeArea(.all)
                
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
                    VStack(spacing: -25) {
                        Image("2lvl1cloud")
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                        WordView(text: currentVerb.infinitive, isBased: true)
                    }
                    .position(x: geo.frame(in: .global).minX + 110, y: geo.size.height/20*4)

                    p_simpleView
                            .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*9)
                                
                    p_participleView
                            .position(x: geo.frame(in: .global).midX, y: geo.size.height/20*11)
                }
                    
                VStack {
                    Spacer()
                    PossibleWordsView(height: 175, onEnded: onEnded, words: possible_words )
                        .padding(.all, 6)
                }
            }
            .onAppear(perform: {
                self.geo = geo
                
                loadVerbs()
                
                p_simpleView.onLongTap = { text in
                    feedback.prepare()
                    guard let text = text else { return }
                    withAnimation {
                        self.possible_words.append(text)
                        p_simpleView.text = nil
                    }
                    self.feedback.notificationOccurred(.error)
                }
                
                p_participleView.onLongTap = { text in
                    feedback.prepare()
                    guard let text = text else { return }
                    withAnimation {
                        self.possible_words.append(text)
                        p_participleView.text = nil
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
                    if p_simpleView.text != nil { possible_words.append(p_simpleView.text!) }
                    p_simpleView.text = choosenWord
                }
            } else {
                withAnimation {
                    if p_participleView.text != nil { possible_words.append(p_participleView.text!) }
                    p_participleView.text = choosenWord
                }
            }
            
            withAnimation {
                self.possible_words.removeAll(where: { $0 == choosenWord })
            }
            return true
            
        } else {
            return false
        }
        
    }
    
    func loadVerbs () {
        nextVerb()
    }
    
    func nextVerb() {
        let verb = IrregVerb(infinitive: "begin", past_simple: "began", past_participle: "begun", other_options: ["begeining", "begot", "begyn"])
        self.currentVerb = verb
        
        p_simpleView.text = nil
        p_participleView.text = nil
        
        var words = verb.other_options
        words.append(verb.past_simple)
        words.append(verb.past_participle)
        self.possible_words = words.shuffled()
    }
}

struct IrregVerbView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IrregVerbView()
                .previewDevice("iPhone 11")
            IrregVerbView()
                .previewDevice("iPhone 8")
        }
    }
}
