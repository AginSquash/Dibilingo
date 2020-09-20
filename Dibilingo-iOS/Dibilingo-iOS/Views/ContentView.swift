//
//  ContentView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 18.09.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // background here
                VStack {
                    NavigationLink(
                        destination: CardView(card: Card(emoji: "🐺", object_name: "wolf", real_name: "wolf")).navigationBarHidden(true),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 100, height: 30, alignment: .center)
                                Text("Level 1")
                                    .foregroundColor(.white)
                            }
                        }).padding(5)
                    
                    NavigationLink(
                        destination: Text("Level 2 here"),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 100, height: 30, alignment: .center)
                                Text("Level 2")
                                    .foregroundColor(.white)
                            }
                        }).padding(5)
                    
                    NavigationLink(
                        destination: Text("Level 3 here"),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 100, height: 30, alignment: .center)
                                Text("Level 3")
                                    .foregroundColor(.white)
                            }
                        }).padding(5)
                    
                    
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
