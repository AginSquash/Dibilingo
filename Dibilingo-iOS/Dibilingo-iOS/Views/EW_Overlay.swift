//
//  EW_Overlay.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct EW_Overlay: View {
    
    let card: Card
    let swiped_right: Bool
    
    var isCorrect: Bool {
        if (card.object_name == card.real_name) && swiped_right { return true }
        if (card.object_name != card.real_name) && !swiped_right { return true }
        return false
    }
    
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 10)
        
                if isCorrect {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .font(.system(size: 40, weight: .heavy))
                        
                        Text("Correct!")
                            .offset(x: 0, y: 3)
                            .font(Font.custom("boomboom", size: 38))
                    }
                } else {
                    VStack {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                                .font(.system(size: 40, weight: .heavy))
                                
                            Text("Wrong!")
                                .offset(x: 0, y: 3)
                                .font(Font.custom("boomboom", size: 38))
                                
                            
                        }.padding(.bottom, 5)
                        
                        HStack {
                            Text("it is a")
                            Text(card.real_name).foregroundColor(.red)
                            Text("!")
                        }
                    }
                }
                
            
        }
        .font(Font.custom("boomboom", size: 32))
        .frame(width: 400, height: 150, alignment: .center)
    }
}

struct EW_Overlay_Previews: PreviewProvider {
    static var previews: some View {
        EW_Overlay(card: Card(emoji: "1", object_name: "wolf", real_name: "wolf"), swiped_right: false)
    }
}
