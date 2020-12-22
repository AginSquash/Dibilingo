//
//  LevelPreview.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import SwiftUI

struct LevelCardView: View {
    var text: String
    var color: Color
    
    let uiscreen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
        RoundedRectangle(cornerRadius: 15)
            .shadow(radius: 10)
            .frame(width: uiscreen.width - 50, height: 75, alignment: .center)
            .padding()
            .foregroundColor(.white)
        
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 75, height: 75, alignment: .center)
                    .foregroundColor(self.color)
                    .padding(.leading, 25)
                Spacer()
            }
            
            HStack {
                Spacer()
                    .frame(width: 25)
                Text(self.text)
                    .multilineTextAlignment(.center)
                    .font(Font.custom("boomboom", size: 32))
                    .foregroundColor(.black)
            }
        }
    }
}


struct LevelPreview: View {
    
    //let uiscreen = UIScreen.main.bounds
    
    @ObservedObject var userprofile: UserProfile_ViewModel
    var category_name: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image("icon_\(category_name)")
                .resizable()
                .shadow(radius: 5)
                .frame(width: 250, height: 250, alignment: .center)
            
            VStack(spacing: -10) {
                LevelCardView(text: "Слова", color: Color(.sRGB, red: 255/255, green: 203/255, blue: 204/255, opacity: 1.0))
                
                LevelCardView(text: "Неправильные\nглаголы", color: Color(.sRGB, red: 211/255, green: 233/255, blue: 255/255, opacity: 1.0))
                
                LevelCardView(text: "Предложения", color: Color(.sRGB, red: 255/255, green: 229/255, blue: 157/255, opacity: 1.0))
                
                
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
