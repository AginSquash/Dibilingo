//
//  CardView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    var removal: ((Bool)->Void)? = nil
    
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1.0
    @State private var moveUP: Bool = false
    
    var feedback: UINotificationFeedbackGenerator?
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(Color(hex: "93bfff"))
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 300, height: 300, alignment: .center)
                    
                    Text(card.emoji)
                        .font(.system(size: 175))
                }
               
                HStack {
                    Text("is it a").foregroundColor(.white)
                    Text(card.object_name.uppercased()).foregroundColor(.red)
                    Text("?").foregroundColor(.white)
                }
                .font(Font.custom("boomboom", size: 42))
            }
        }
        .opacity(opacity)
        .offset(y: moveUP ? -1000 : 0)
        .frame(width: 325, height: 400, alignment: .center)
        .rotationEffect(.degrees(Double(offset.width) / 7 ))
        .offset(x: offset.width / 2, y: 0)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    self.offset = gesture.translation
                    self.opacity = 1.5 - Double(abs(self.offset.width)) / 200
                    self.feedback?.prepare()
                })
                .onEnded({ _ in
                    
                    if abs(self.offset.width) > 150 {
                        withAnimation {
                            opacity = 0
                        }
                        
                        self.removal?(self.offset.width > 150 ? true : false)
                        self.offset = CGSize.zero
                       // moveUP = true
                        
                        withAnimation(.easeIn(duration: 1.0)) {
                            opacity = 1.0
                         //   moveUP = false
                        }
                    } else {
                        withAnimation {
                            self.offset = CGSize.zero
                        }
                    }
                })
        )
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(emoji: "🐺", object_name: "wolf", real_name: "wolf"))
    }
}
