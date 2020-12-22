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
    @State private var reader: ScrollViewProxy?
    @State private var currentCategory: Int = 0
    @State private var isAnimation = false
    @ObservedObject var userprofile = UserProfile_ViewModel()
    
    var body: some View {
        //GeometryReader { fullView in
        NavigationView {
        ZStack {
            
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            
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

            ZStack {
                HStack {
                    Button(action: {
                        guard isAnimation == false else { return }
                        guard currentCategory != 0 else { return }
                        isAnimation = true
                        currentCategory -= 1
                        withAnimation {
                            reader?.scrollTo(categories[currentCategory], anchor: .center)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isAnimation = false
                        }
                    }, label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    })
                    .disabled(currentCategory == 0)
                    
                    Spacer()
                    Button(action: {
                        guard isAnimation == false else { return }
                        guard currentCategory != categories.count - 1 else { return }
                        isAnimation = true
                        currentCategory += 1
                        withAnimation {
                            reader?.scrollTo(categories[currentCategory], anchor: .center)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isAnimation = false
                        }
                    }, label: {
                        Image(systemName: "arrow.right")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            
                    })
                    .disabled(currentCategory == categories.count-1)
                }
                .zIndex(2)
                .allowsHitTesting(true)
                .padding()
                
                ZStack {
                    //Rectangle()
                    //    .opacity(0.5)
                    //    .zIndex(1)
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { reader in
                            HStack {
                                ForEach(categories, id: \.self) { element in
                                        LevelPreview(userprofile: userprofile, category_name: element.name)
                                            .frame(width: uiscreen.width, alignment: .center)
                                            .zIndex(2)
                                }
                            }
                            .onAppear(perform: {
                                self.reader = reader
                            })
                        }
                    }.disabled(true)
                }
                .zIndex(0)
            }
        }
        }
        .navigationBarHidden(true)
    }
}

struct MainmenuView_ver2_Previews: PreviewProvider {
    static var previews: some View {
        MainmenuView_ver2()
    }
}
