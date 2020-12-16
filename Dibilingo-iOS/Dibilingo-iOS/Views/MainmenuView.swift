//
//  MainmenuView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct MainmenuView: View {
    
    var categories = [Category(id: 0, name: "cat"), Category(id: 1, name: "train"), Category(id: 2, name: "weather"), Category(id: 3, name: "random")]
      
    @State var geo: GeometryProxy?
    
    @ObservedObject var userprofile = UserProfile_ViewModel()
    @State private var totalCoins: Int = 0
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    Color(hex: "6495ed")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: geo.frame(in: .global).width, height: 80, alignment: .center)
                                .opacity(0.5)
                            HStack {
                                Text("\(userprofile.profile?.name ??  "Unknown")")
                                    .font(Font.custom("boomboom", size: 32))
                                    .foregroundColor(.white)
                                    .offset(y: 14)
                                    .onTapGesture(count: 1, perform: {
                                        userprofile._SaveAndUpload()
                                    })
                                
                                Spacer()
                                
                                Text("\(totalCoins)")
                                    .font(Font.custom("Coiny", size: 38))
                                    .foregroundColor(.white)
                                    .offset(y: 12)
                                    .onTapGesture {
                                        self.totalCoins = userprofile.getTotalCoins()
                                    }
                            }
                            .padding(.horizontal)
                        }
                        .edgesIgnoringSafeArea(.top)
                        Spacer()
                    }.zIndex(3)
                    
                    ScrollView {
                        
                        VStack {
                            
                            Rectangle()
                                .frame(width: 100, height: 150, alignment: .center)
                                .opacity(0)
                            
                            ForEach(categories) { category in
                                LevelPreview(userprofile: userprofile, category_name: category.name)
                                    .position(x: category.id % 2 == 0 ? geo.frame(in: .global).maxX - 145 : geo.frame(in: .global).minX + 145 )
                            }
                            
                        }
                    
                        
                    }
                }
                .navigationBarHidden(true)
                .onAppear(perform: {
                    self.geo = geo
                    //print("MainmenuView appered")
                    self.userprofile.mainmenuLoad()
                    self.totalCoins = userprofile.getTotalCoins()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                        self.totalCoins = userprofile.getTotalCoins()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.totalCoins = userprofile.getTotalCoins()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.totalCoins = userprofile.getTotalCoins()
                    }
                    
                })
            }
        }
    }
}

struct MainmenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainmenuView()
                .previewDevice("iPhone 11")
            MainmenuView()
                .previewDevice("iPhone 8")
        }
    }
}
