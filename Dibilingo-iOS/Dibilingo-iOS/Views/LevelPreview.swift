//
//  LevelPreview.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct LevelPreview: View {
    
    let uiscreen = UIScreen.main.bounds
    
    @ObservedObject var userprofile: UserProfile_ViewModel
    var category_name: String
    
    //@State private var showPopup: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            Image("icon_\(category_name)")
                .resizable()
                .shadow(radius: 5)
                .frame(width: 250, height: 250, alignment: .center)
            
            VStack(spacing: -10) {
                ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .shadow(radius: 10)
                    .frame(width: uiscreen.width - 50, height: 75, alignment: .center)
                    .padding()
                    .foregroundColor(.white)
                
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 75, height: 75, alignment: .center)
                            .foregroundColor(Color(.sRGB, red: 255/255, green: 203/255, blue: 204/255, opacity: 1.0))
                            .padding(.leading, 25)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 25)
                        Text("Слова")
                            .font(Font.custom("boomboom", size: 32))
                    }
                }
                
                ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .shadow(radius: 10)
                    .frame(width: uiscreen.width - 50, height: 75, alignment: .center)
                    .padding()
                    .foregroundColor(.white)
                
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 75, height: 75, alignment: .center)
                            .foregroundColor(Color(.sRGB, red: 211/255, green: 233/255, blue: 255/255, opacity: 1.0))
                            .padding(.leading, 25)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 25)
                        Text("Неправильные\nглаголы")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("boomboom", size: 32))
                    }
                }
                
                ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .shadow(radius: 10)
                    .frame(width: uiscreen.width - 50, height: 75, alignment: .center)
                    .padding()
                    .foregroundColor(.white)
                
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 75, height: 75, alignment: .center)
                            .foregroundColor(Color(.sRGB, red: 255/255, green: 229/255, blue: 157/255, opacity: 1.0))
                            .padding(.leading, 25)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 25)
                        Text("Предложения")
                            .font(Font.custom("boomboom", size: 32))
                    }
                }
            }
            /*
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
                            destination: SentenceFromWords(userprofile: userprofile, category_name: category_name),
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
                        
                    } */
                //}
        }
    }
}

struct LevelPreview_Previews: PreviewProvider {
    static var previews: some View {
        let up = UserProfile_ViewModel()
        return LevelPreview(userprofile: up, category_name: "cat")
    }
}
