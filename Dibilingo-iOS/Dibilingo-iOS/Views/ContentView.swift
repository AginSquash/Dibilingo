//
//  ContentView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 18.09.2020.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        
        return MainmenuView()
        
         NavigationView {
            ZStack {
                SwiftUIGIFPlayerView(gifName: "orig")
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                VStack {
                    NavigationLink(
                        destination: EmojiWordView().navigationBarHidden(true),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 150, height: 50, alignment: .center)
                                Text("Level ")
                                    .font(Font.custom("boomboom", size: 32))
                                    .foregroundColor(.white)
                                +
                                Text("1")
                                    .font(Font.custom("Coiny", size: 32))
                                    .foregroundColor(.white)
                            }
                        }).padding(5)
                    
                    NavigationLink(
                        destination: IrregVerbView(),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 150, height: 50, alignment: .center)
                                Text("Level ")
                                    .font(Font.custom("boomboom", size: 32))
                                    .foregroundColor(.white)
                                +
                                Text("2")
                                    .font(Font.custom("Coiny", size: 32))
                                    .foregroundColor(.white)
                            }
                        }).padding(5)
                    
                    NavigationLink(
                        destination: Text("Level 3 here"),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 150, height: 50, alignment: .center)
                                Text("Level ")
                                    .font(Font.custom("boomboom", size: 32))
                                    .foregroundColor(.white)
                                +
                                Text("3")
                                    .font(Font.custom("Coiny", size: 32))
                                    .foregroundColor(.white)
                            }
                        }).padding(5)
                                        
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print(getUserProfile())
            }
         })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
