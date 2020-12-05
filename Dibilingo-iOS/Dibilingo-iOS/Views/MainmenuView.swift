//
//  MainmenuView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct cutomIcon: View {
    var icon_name: String
    
    /*
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
    } */
    
    @State private var showPopup: Bool = false
    
    var body: some View {
        VStack {
            Image(icon_name)
                .resizable()
                .shadow(radius: 5)
                .frame(width: 200, height: 200, alignment: .center)
                .offset(y: showPopup ? 75 : 0 )
                .onTapGesture(count: 1, perform: {
                    withAnimation { showPopup.toggle() }
                })
            if showPopup {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 275, height: 150, alignment: .center)
                        .foregroundColor(.yellow)
                    HStack {
                        NavigationLink(
                            destination: EmojiWordView().navigationBarHidden(true),
                            label: {
                                ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 75, height: 100, alignment: .center)
                                Text("1")
                                    .font(Font.custom("Coiny", size: 42))
                                    .foregroundColor(.white)
                                }
                            })
                        //
                        
                        NavigationLink(
                            destination: IrregVerbView(),
                            label: {
                                ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 75, height: 100, alignment: .center)
                                Text("2")
                                    .font(Font.custom("Coiny", size: 42))
                                    .foregroundColor(.white)
                                }
                            })
                        //
                        
                        NavigationLink(
                            destination: Text("3 lvl"),
                            label: {
                                ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 75, height: 100, alignment: .center)
                                Text("3")
                                    .font(Font.custom("Coiny", size: 42))
                                    .foregroundColor(.white)
                                }
                            })
                        //
                        
                    }
                }
                .offset(y: 75)
            }
        }
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
                        
                        Rectangle()
                            .frame(width: 100, height: 100, alignment: .center)
                            .opacity(0)
                        
                        ForEach(categories) { category in
                            cutomIcon(icon_name: category.name)
                                .position(x: geo.frame(in: .global).midX + 65 * (category.id % 2 == 0 ? 1: -1))
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
