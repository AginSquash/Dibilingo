//
//  WordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct WordView: View {
    var text: String
    
    var computedWidth: CGFloat {
        let width = 130 + ((text.count - 7) * 15)
        return CGFloat(width)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                .foregroundColor(.yellow)
            Text(text.uppercased())
                .font(Font.custom("boomboom", size: 30))
                .foregroundColor(.white)
        }
        .frame(width: computedWidth, height: 45, alignment: .center)
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(text: "SampAAA")
    }
}
