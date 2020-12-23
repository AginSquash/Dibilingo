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
                    gradient: .init(colors: [Color.red, Color.purple]), //.init(colors: [Self.gradientStart, Self.gradientEnd])
                      startPoint: .init(x: 0.5, y: 0),
                      endPoint: .init(x: 0.5, y: 0.6)
                    ))
                .frame(width: self.uiscreen.width+100,
                        height: self.uiscreen.width+100,
                        alignment: .center)
                .position(x: self.uiscreen.midX)
            
            ZStack {
                HStack {
                    Button(action: {
                        guard isAnimation == false else { return }
                        guard currentCategory != 0 else { return }
                        isAnimation = true
                        
                        
                        withAnimation {
                            currentCategory -= 1
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
                        
                        withAnimation {
                            currentCategory += 1
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
                .allowsHitTesting(true)
                .padding()
                
                
                /*
                 
                 PageView(index: $currentCategory, pages: self.previews.map({ base in
                     PageView.Page {
                         base
                     }
                 }) )
                 
                 PageView(index: $currentCategory) {
                     
                         PageView.Page {
                             ForEach(categories, id: \.self) { element in
                             AnyView( ZStack {
                             LevelPreview(userprofile: userprofile, category_name: element.name)
                                 .frame(width: uiscreen.width, alignment: .center)
                             }
                             )
                         }
                     }
                 }
                 
                 */
                 
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
                        }
                        .padding(.bottom, 20)
                    }
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
            MainmenuView_ver2()
            MainmenuView_ver2()
                .previewDevice("iPhone 8")
        }
    }
}
