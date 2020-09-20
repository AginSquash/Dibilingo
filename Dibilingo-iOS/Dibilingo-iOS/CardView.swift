//
//  CardView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 20.09.2020.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(Color.yellow)
            ZStack {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .fill(Color.white)
                    .frame(width: 300, height: 300, alignment: .center)
                
                Text("🐺")
                    .font(.system(size: 150))
            }
           
        }
        .frame(width: 325, height: 325, alignment: .center)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
