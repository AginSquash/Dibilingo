//
//  EW_Overlay.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EW_Overlay: View {
    
    @Binding var needCorrectAnswer: String?
    @State var answerCopy: String = ""
    var customView: Bool = false
    var showCorrectAnswerLabel: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 15)
        
            VStack {
                HStack {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .font(.system(size: 40, weight: .heavy))
                                
                    Text("Wrong!")
                        .offset(x: 0, y: 3)
                        .font(Font.custom("boomboom", size: 38))
                        .foregroundColor(.black)
                            
                }.padding(.bottom, 5)
                
                if showCorrectAnswerLabel {
                    Text("Correct: ").foregroundColor(.black)
                        .padding(.leading)
                }
                
                    HStack {
                        if self.customView == false {
                            Text("it is a").foregroundColor(.black)
                        }
                        
                        Text(answerCopy).foregroundColor(.red)
                            .padding(self.customView ? [.trailing] : [])
                        if self.customView == false {
                            Text("!").foregroundColor(.black)
                        }
                    }
            }
        }
        .onAppear(perform: {
            answerCopy = needCorrectAnswer ?? "ERROR"
        })
        .font(Font.custom("boomboom", size: 32))
        .frame(width: 400, height: showCorrectAnswerLabel ? 200 : 150, alignment: .center)
        .onTapGesture(count: 1, perform: {
            withAnimation {
                needCorrectAnswer = nil
            }
        })
    }
}

struct EW_Overlay_Previews: PreviewProvider {
    static var previews: some View {
        //EW_Overlay(card: Card(emoji: "1", object_name: "wolf", real_name: "wolf"), swiped_right: false)
        EW_Overlay(needCorrectAnswer: .constant("Cat"))
    }
}
