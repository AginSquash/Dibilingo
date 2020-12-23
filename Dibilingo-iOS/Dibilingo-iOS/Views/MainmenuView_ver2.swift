//
//  MainmenuView_ver2.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 22.12.2020.
//

import SwiftUI
import UIKit
import Introspect

struct MainmenuView: View {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)

    let uiscreen = UIScreen.main.bounds
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var categories = [Category(id: 0, name: "animals", locale_name: "Животные", gradient: ["#facfb6", "#ffcbee"]),
                      Category(id: 1, name: "transport", locale_name: "Транспорт", gradient: ["#baefd6", "#508add"]),
                      Category(id: 2, name: "weather", locale_name: "Погода", gradient: ["#fff5a7", "#fdb5a3"]),
                      Category(id: 3, name: "random", locale_name: "Рандом", gradient: ["#baefd6", "#508add"] )]
    
    @State private var offset: CGFloat = 0
    @State private var reader: ScrollViewProxy?
    @State private var currentCategory: Int = 0
    @State private var isAnimation = false
    @ObservedObject var userprofile = UserProfile_ViewModel()
    
    var body: some View {
        
        NavigationView {
        ZStack {
            
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            
            
            Circle()
                .fill(LinearGradient(
                    gradient: .init(colors: self.categories[currentCategory].gradient.map({ Color(hex: $0) })),
                    startPoint: .init(x: 0.5, y: 0.3),
                      endPoint: .init(x: 0.5, y: 0.6)
                    ))
                .frame(width: self.uiscreen.width+100,
                        height: self.uiscreen.width+100,
                        alignment: .center)
                .position(x: self.uiscreen.midX)

     
            Text(self.categories[currentCategory].locale_name)
                .foregroundColor(.white)
                .font(Font.custom("boomboom", size: 40))
                .shadow(radius: 5 )
                .edgesIgnoringSafeArea(.all)
                .position(x: self.uiscreen.midX, y: self.uiscreen.minY + 25)
                    
             
            
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
                .offset(y: -65)
                .zIndex(2)
                .allowsHitTesting(true)
                .padding()
                
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { reader in
                            HStack {
                                ForEach(categories, id: \.self) { element in
                                        LevelPreview(userprofile: userprofile, category_name: element.name)
                                            .frame(width: uiscreen.width, alignment: .center)
                                }
                            }
                            .onAppear(perform: {
                                self.reader = reader
                            })
                        }
                        .introspectScrollView() { scrollView in
                            scrollView.isPagingEnabled = true
                        }
                    }
                    .padding(.bottom, 20)
                }
                .zIndex(0)
            }
        }
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.userprofile.mainmenuLoad()
        })
    }
}

struct MainmenuView_ver2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainmenuView()
            MainmenuView()
                .previewDevice("iPhone 8")
        }
    }
}
