//
//  WordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct WordView: View {
    var text: String?
    var isBased: Bool = false
    var onEnded: ((DragGesture.Value, String) -> Void)?
    
    var computedWidth: CGFloat {
        guard let text = text else { return 60 }
        let width = 130 + ((text.count - 7) * 15)
        return CGFloat(width)
    }
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                .foregroundColor( self.text != nil ? .yellow : .gray)
            Text(text?.uppercased() ?? "...")
                .font(Font.custom("boomboom", size: 30))
                .foregroundColor(.white)
        }
        .frame(width: computedWidth, height: 45, alignment: .center)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged({ value in
                    if isBased  { return }
                    self.offset = value.translation
                    print(value.location)
                })
                .onEnded({ value in
                    withAnimation {
                        offset = CGSize.zero
                    }
                    (onEnded ?? { _,_ in })(value, text ?? "")
                })
        )
        .offset(offset)
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView()
    }
}
