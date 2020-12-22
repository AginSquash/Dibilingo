//
//  MainmenuView_ver2.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 22.12.2020.
//

import SwiftUI

struct MainmenuView_ver2: View {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)

    let uiscreen = UIScreen.main.bounds
    
    var categories = [Category(id: 0, name: "cat"), Category(id: 1, name: "train"), Category(id: 2, name: "weather"), Category(id: 3, name: "random")]
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                      gradient: .init(colors: [Self.gradientStart, Self.gradientEnd]),
                      startPoint: .init(x: 0.5, y: 0),
                      endPoint: .init(x: 0.5, y: 0.6)
                    ))
                .frame(width: self.uiscreen.width+100,
                        height: self.uiscreen.width+100,
                        alignment: .center)
                .position(x: self.uiscreen.midX)
            
            ScrollView(.horizontal, showsIndicators: false ) {
                ScrollViewReader { value in
                    HStack {
                        Rectangle()
                            .frame(width: 50, height: 150, alignment: .center)
                            .onTapGesture {
                                withAnimation {
                                value.scrollTo(categories[2], anchor: .center)
                                }
                            }
                        
                        ForEach(categories, id: \.self) { element in
                            Image("icon_\(element.name)")
                                .resizable()
                                .frame(width: 275, height: 275, alignment: .center)
                                .shadow(radius: 10)
                                .highPriorityGesture(
                                    DragGesture()
                                        .onChanged({ gesture in
                                            self.offset = gesture.translation.width
                                            
                                            /*
                                            print(offset)
                                            
                                            if offset < -15 {
                                                withAnimation {
                                                    value.scrollTo(categories[1], anchor: .center)
                                                    print("Scrolled!")
                                                }
                                            } */
                                        })
                                        .onEnded({ _ in
                                            print("OK")
                                            
                                            print(offset)
                                            
                                            if offset < -15 {
                                                withAnimation {
                                                    value.scrollTo(categories[1], anchor: .center)
                                                }
                                            }
                                            
                                        })
                                )
                        }
                        
                        Rectangle()
                            .frame(width: 50, height: 150, alignment: .center)
                    }
                }
            }
            
            //Text("Ok")
        }
    }
}

struct MainmenuView_ver2_Previews: PreviewProvider {
    static var previews: some View {
        MainmenuView_ver2()
    }
}
