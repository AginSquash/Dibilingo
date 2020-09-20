//
//  CardView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct CardView: View {
    
    @State private var offset = CGSize.zero
    
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(Color(hex: "93bfff"))
                //.fill(Color(.sRGB, red: 0.5764705882352941, green: 0.7490196078431373, blue: 1.0, opacity: 1.0))
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
        .frame(width: 325, height: 400, alignment: .center)
        .rotationEffect(.degrees(Double(offset.width) / 7 ))
        .offset(x: offset.width / 2, y: 0)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    self.offset = gesture.translation
                })
                .onEnded({ _ in
                    // delete card
                    withAnimation {
                        self.offset = CGSize.zero
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
