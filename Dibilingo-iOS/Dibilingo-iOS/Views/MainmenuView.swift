//
//  MainmenuView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct cutomIcon: View {
    var icon_name: String
    
    var destination: some View {
        switch icon_name {
        case "icon_cat":
            return AnyView(EmojiWordView().navigationBarHidden(true))
        case "icon_train":
            return AnyView(IrregVerbView())//.navigationBarHidden(true)
        default:
            return AnyView(Text("Level 3 here"))
        }
        //return Text("Level 3 here").navigationBarHidden(true)
    }
    
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                Image(icon_name)
                    .resizable()
                    .shadow(radius: 5)
                    .frame(width: 200, height: 200, alignment: .center)
            })
    }
}

struct MainmenuView: View {
    
    var categories = [Category(id: 0, name: "icon_cat"), Category(id: 1, name: "icon_train"), Category(id: 2, name: "icon_cat"), Category(id: 3, name: "icon_train"), Category(id: 4, name: "icon_cat"), Category(id: 5, name: "icon_train"), Category(id: 6, name: "icon_cat")]
    
    @State var geo: GeometryProxy?
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    ScrollView {
                        
                        ForEach(categories) { category in
                            cutomIcon(icon_name: category.name)
                                .position(x: geo.frame(in: .global).midX + 70 * (category.id % 2 == 0 ? 1: -1) , y: 100)
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear(perform: {
                    self.geo = geo
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
