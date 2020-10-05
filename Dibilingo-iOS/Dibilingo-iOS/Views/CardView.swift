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
                //.fill(Color(hex: "93bfff"))
                .fill(Color.yellow)
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 300, height: 300, alignment: .center)
                    
                    Image(uiImage:  card.image)
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                }
               
                HStack {
                    Text("is it a").foregroundColor(.white)
                    Text(card.object_name.uppercased()).foregroundColor(.red)
                    Text("?").foregroundColor(.white)
                }
                .font(Font.custom("boomboom", size: 42))
            }
        }
        
        .shadow(radius: -1, x: 0, y: 1)
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
                    
                    if abs(self.offset.width) > 250 {
                        withAnimation {
                            opacity = 0
                        }
                        
                        self.removal?(self.offset.width > 250 ? true : false)
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
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let data = try? Data(contentsOf: baseURL.appendingPathComponent("wolf.jpg"))
        let image = UIImage(data: data!)!
        return CardView(card: Card(image: image, object_name: "wolf", real_name: "wolf"))
    }
}
