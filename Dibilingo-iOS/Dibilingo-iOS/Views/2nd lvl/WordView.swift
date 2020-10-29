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
    var onEnded: ((DragGesture.Value, String) -> Bool)?
    var onLongTap: ((String?) -> Void)?
    
    var computedWidth: CGFloat {
        guard let text = text else { return 60 }
        let width = 130 + ((text.count - 7) * 15)
        return CGFloat(width)
    }
    
    @State private var offset = CGSize.zero
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                .foregroundColor( self.text != nil ? .yellow : .gray)
            Text(text?.uppercased() ?? "...")
                .font(Font.custom("boomboom", size: 30))
                .foregroundColor(.white)
        }
        .frame(width: computedWidth, height: 45, alignment: .center)
        .onLongPressGesture {
            (onLongTap ?? { _ in })(self.text)
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged({ value in
                    if isBased || text == nil { return }
                    self.offset = value.translation
                    //print(value.location)
                })
                .onEnded({ value in
                    let isSetted = (onEnded ?? { _,_ in return false })(value, text ?? "")
                    
                    if isSetted == false {
                        withAnimation {
                            offset = CGSize.zero
                        }
                        return
                    } else {
                        opacity = 0
                        offset = CGSize.zero
                        
                    }
                })
        )
        .offset(offset)
        .opacity(opacity)
        .onDisappear(perform: {
            opacity = 0
            offset = CGSize.zero
        })
        .onAppear(perform: {
            opacity = 1
            offset = CGSize.zero
        })
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView()
    }
}
