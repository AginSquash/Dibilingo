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
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var categories = [Category(id: 0, name: "cat"), Category(id: 1, name: "train"), Category(id: 2, name: "weather"), Category(id: 3, name: "random")]
    
    @State private var offset: CGFloat = 0
    @ObservedObject var userprofile = UserProfile_ViewModel()
    
    var body: some View {
        //GeometryReader { fullView in
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
            
            /*ScrollView(.horizontal, showsIndicators: false ) {
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
                        }
                        
                        Rectangle()
                            .frame(width: 50, height: 150, alignment: .center)
                    }
                }
            } */
            
            //Text("Ok")

            
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { element in
                            GeometryReader { geo in
                                //Image("icon_\(element.name)")
                                    //.resizable()
                                    //.frame(width: 250, height: 250, alignment: .center)
                                LevelPreview(userprofile: userprofile, category_name: element.name)
                                    .frame(width: 250, height: uiscreen.width, alignment: .center)
                                    //.shadow(radius: 10)
                                    .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - uiscreen.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                            }
                            .frame(width: 250)
                        }
                    }
                    .padding(.horizontal, (uiscreen.width - 250) / 2)
                }
                .offset(y: uiscreen.midY/3)
                //.position(x: uiscreen.midX, y: uiscreen.midY)
           // }
           // .position(x: uiscreen.midX, y: uiscreen.midY)
        }
    }
}

struct MainmenuView_ver2_Previews: PreviewProvider {
    static var previews: some View {
        MainmenuView_ver2()
    }
}
