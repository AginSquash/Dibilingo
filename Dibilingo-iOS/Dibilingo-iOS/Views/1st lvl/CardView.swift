//
//  CardView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    let isLastCard: Bool
    var removal: ((Bool)->Void)? = nil
    var feedback: UINotificationFeedbackGenerator?
    
    var computedFontSize: CGFloat {
        if card.object_name.count < 7 {
            return 42
        } else {
            let fontSize = 42 - (card.object_name.count - 7) * 3
            return CGFloat(fontSize)
        }
    }
    
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1.0
    @State private var moveUP: Bool = false
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(Color.yellow)
                .shadow(isLast: isLastCard)
            
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
                    Text("Это").foregroundColor(.white)
                    Text(card.object_name.uppercased()).foregroundColor(.red)
                    Text("?").foregroundColor(.white)
                }
                .font(Font.custom("boomboom", size: computedFontSize))
                .offset(y: computedFontSize < 42 ? 10 : 0)
                .shadow(radius: 0 )
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
                    
                    if abs(self.offset.width) > 200 {
                        withAnimation {
                            opacity = 0
                        }
                        
                        self.removal?(self.offset.width > 200 ? true : false)
                        self.offset = CGSize.zero
                        
                        withAnimation(.easeIn(duration: 1.0)) {
                            opacity = 1.0
                        }
                    } else {
                        withAnimation {
                            self.offset = CGSize.zero
                            opacity = 1.0
                        }
                    }
                })
        )
    }
    
}

extension View {
    func shadow(isLast: Bool) -> some View {
        if isLast { return self.shadow(radius: 0, x: 0, y: 0)  }
        return self.shadow(radius: -1, x: 0, y: 1)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let image = UIImage(named: "wolf.png")!
        return CardView(card: Card(image: image, object_name: "watermelon", real_name: "wolf"), isLastCard: false)
    }
}
