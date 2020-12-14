//
//  LevelPreview.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct LevelPreview: View {
    
    @ObservedObject var userprofile: UserProfile_ViewModel
    var category_name: String
    
    @State private var showPopup: Bool = false
    
    var body: some View {
        VStack(spacing: -5) {
            Image("icon_\(category_name)")
                .resizable()
                .shadow(radius: 5)
                .frame(width: 200, height: 200, alignment: .center)
                .offset(y: showPopup ? 72.5 : 0 )
                .onTapGesture(count: 1, perform: {
                    withAnimation { showPopup.toggle() }
                })
            if showPopup {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 275, height: 150, alignment: .center)
                        .foregroundColor(.yellow)
                    HStack {
                        
                        // Card level
                        NavigationLink(
                            destination: EmojiWordView(userprofile: userprofile, category_name: category_name).navigationBarHidden(true),
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
                        
                        // Irreg Verbs
                        NavigationLink(
                            destination: IrregVerbView(userprofile: userprofile, category_name: category_name),
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
                        
                        // Level 3
                        NavigationLink(
                            destination: SentenceFromWords(),
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
                .offset(y: 72.5)
            }
        }
    }
}

struct LevelPreview_Previews: PreviewProvider {
    static var previews: some View {
        let up = UserProfile_ViewModel()
        return LevelPreview(userprofile: up, category_name: "cat")
    }
}
