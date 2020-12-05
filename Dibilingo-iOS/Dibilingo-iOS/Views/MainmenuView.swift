//
//  MainmenuView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct MainmenuView: View {
    
    var categories = [Category(id: 0, name: "cat"), Category(id: 1, name: "train"), Category(id: 2, name: "cat"), Category(id: 3, name: "train"), Category(id: 4, name: "cat"), Category(id: 5, name: "train"), Category(id: 6, name: "cat")]
    
    @State var geo: GeometryProxy?
    
    @ObservedObject var userprofile = UserProfile_ViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    Color(hex: "6495ed")
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                    
                        Rectangle()
                            .frame(width: 100, height: 100, alignment: .center)
                            .opacity(0)
                        
                        ForEach(categories) { category in
                            LevelPreview(level_name: category.name)
                                .position(x: category.id % 2 == 0 ? geo.frame(in: .global).maxX - 145 : geo.frame(in: .global).minX + 145 )
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear(perform: {
                    self.geo = geo
                    print("MainmenuView appered")
                    self.userprofile.mainmenuLoad()
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
