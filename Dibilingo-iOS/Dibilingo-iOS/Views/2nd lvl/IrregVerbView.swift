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
    @State private var cloudSize: CGFloat = 175
    @State private var possible_words: [String] = []
    
    @State var p_simpleView = WordView(isBased: true)
    @State var p_participleView = WordView(isBased: true)
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @State private var coins: Int = 0
    var ScoreText: String {
        return "\(coins)/54"
    }
    @State private var isPointUp: Bool = false
    
    @State private var currentVerb: IrregVerb = IrregVerb(infinitive: "begin", past_simple: "began", past_participle: "begun", other_options: ["example", "example"])
    @State private var needShowCorrectAnswer: String? = nil
    
    @State private var verbs: [IrregVerb] = []
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                //Color(hex: "#3F92D2")
                //    .edgesIgnoringSafeArea(.all)
                Color(hex: "#ddf0ff")
                    .edgesIgnoringSafeArea(.top)
                VStack(spacing: 0) {
                    Image("ship_400_400_drugoy")
                        .resizable()
                        .frame(width: geo.size.width*0.7, height: geo.size.width*0.7, alignment: .center)
                        //.offset(x: 30)
                    Color(hex: "#a5dddd")
                }
                .edgesIgnoringSafeArea([.top, .bottom])
                
                VStack {
                    HStack {
                        
                        Text("Go Back")
                            .foregroundColor(.red)
                            .font(Font.custom("boomboom", size: 42))
                            .padding(.leading)
                            .onTapGesture(count: 1, perform: {
                                self.mode.wrappedValue.dismiss()
                            })
                        
                        Spacer()
                        if isPointUp {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(.green)
                                .transition(.opacity)
                        }
                        Text("\(coins)/54")
                            .foregroundColor(.blue)
                            .font(Font.custom("Coiny", size: 38))
                            .padding(.trailing)
                    }
                    Spacer()
                }
                .zIndex(1)
                
                ZStack {
                    
                    /*
                    VStack(spacing: -20) {
                        Image("cloud1")
                            .resizable()
                            .frame(width: cloudSize, height: cloudSize, alignment: .center)
                        WordView(text: currentVerb.infinitive, isBased: true)
                    }
                    .position(x: geo.frame(in: .global).minX + 110, y: geo.size.height/100*25)
                    */
                    
                    WordView(text: currentVerb.infinitive, isBased: true)
                        .position(x: geo.frame(in: .global).midX, y: geo.size.height/100*45)
                    
                    p_simpleView
                        .position(x: geo.frame(in: .global).midX, y: geo.size.height/100*55)
                                
                    p_participleView
                        .position(x: geo.frame(in: .global).midX, y: geo.size.height/100*65)
                }
                    
                VStack {
                    Spacer()
                    PossibleWordsView(height: 175, onEnded: onEnded, words: possible_words )
                        .padding(.all, 6)
                }
                .allowsHitTesting(needShowCorrectAnswer == nil ? true : false)
            }
            .zIndex(2)
            .onAppear(perform: {
                self.geo = geo
                self.cloudSize = geo.size.height/100*25
                
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
            
            if needShowCorrectAnswer != nil {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        EW_Overlay(needCorrectAnswer: $needShowCorrectAnswer, customView: true)
                        Spacer()
                    }
                    Spacer()
                }
                .transition(.slide)
                .zIndex(3)
                .allowsHitTesting(true)
            }
            
        }
        .navigationBarHidden(true)
    }
    
    func onEnded(value: DragGesture.Value, choosenWord: String) -> Bool {
        
        //print("Ok")
        //print(choosenWord)
        
        guard let geo = self.geo else { return false }
       
        //print(geo.frame(in: .global).midX)
        
        /*
        let offsetByImageCenter: CGFloat = 15 //offset needed to move hitbox on 15 pixels down by Y
        
        let maxX = geo.frame(in: .global).maxX
        if (value.location.x > maxX - 150)&&(value.location.x < maxX - 50) {
            let height =  geo.size.height/100*(40 + offsetByImageCenter)
            if (value.location.y > height) && (value.location.y < height + 50) {
                withAnimation {
                    if p_simpleView.text != nil { possible_words.append(p_simpleView.text!) }
                    p_simpleView.text = choosenWord
                    self.possible_words.removeAll(where: { $0 == choosenWord })
                }
                checkCorrect()
                return true
            }
        }
        
        let minX = geo.frame(in: .global).minX
        if (value.location.x > minX + 50)&&(value.location.x < minX + 150) {
            let height =  geo.size.height/100*(55 + offsetByImageCenter)
            if (value.location.y > height) && (value.location.y < height + 50) {
                
                print("pos3")
                
                withAnimation {
                    if p_participleView.text != nil { possible_words.append(p_participleView.text!) }
                    p_participleView.text = choosenWord
                    self.possible_words.removeAll(where: { $0 == choosenWord })
                }
                checkCorrect()
                return true
            }
        } */
        
        let midX = geo.frame(in: .global).midX
        if (value.location.x > midX - 50)&&(value.location.x < midX + 50) {
            
            let height =  geo.size.height/100
            if (value.location.y > height * 55) && (value.location.y < height * 65) {
                p_simpleView.text = choosenWord
                withAnimation {
                    if p_simpleView.text != nil { possible_words.append(p_simpleView.text!) }
                    //p_simpleView.text = choosenWord
                    self.possible_words.removeAll(where: { $0 == choosenWord })
                }
                checkCorrect()
                return true
            }
            
            if (value.location.y > height * 65) && (value.location.y < height * 75) {
                p_participleView.text = choosenWord
                withAnimation {
                    if p_participleView.text != nil { possible_words.append(p_participleView.text!) }
                    //p_participleView.text = choosenWord
                    self.possible_words.removeAll(where: { $0 == choosenWord })
                }
                checkCorrect()
                return true
            }
        }
        
        return false
        
    }
    
    func loadVerbs () {
        self.verbs.append(IrregVerb(infinitive: "begin", past_simple: "began", past_participle: "begun", other_options: ["begeining", "begot", "begyn", "begon"]))
        self.verbs.append(IrregVerb(infinitive: "see", past_simple: "saw", past_participle: "seen", other_options: ["seenning", "sawed", "seed", "sow"]))
        self.verbs.append(IrregVerb(infinitive: "ring", past_simple: "rang", past_participle: "rung", other_options: ["running", "run", "ranned", "ran"]))
        
        nextVerb()
    }
    
    func nextVerb() {
        guard self.verbs.count > 0 else {
            withAnimation { self.needShowCorrectAnswer = "End of the demo" }
            return
        }
        
        let verb = self.verbs.removeFirst()
        self.currentVerb = verb
        
        p_simpleView.text = nil
        p_participleView.text = nil
        
        var words = verb.other_options
        words.append(verb.past_simple)
        words.append(verb.past_participle)
        self.possible_words = words.shuffled()
    }
    
    func checkCorrect() {
        guard let p_simple = p_simpleView.text else { return }
        guard let p_participle = p_participleView.text else { return }
        
        if (p_simple == currentVerb.past_simple)&&(p_participle == currentVerb.past_participle) {
            
            withAnimation(.easeIn(duration: 0.5), { isPointUp = true })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {  self.coins += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.5), { isPointUp = false })
            }
            
            withAnimation {
                nextVerb()
            }
            
        } else {
            withAnimation {
                self.needShowCorrectAnswer = "\(currentVerb.infinitive)-\(currentVerb.past_simple)-\(currentVerb.past_participle)"
                nextVerb()
            }
        }
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
