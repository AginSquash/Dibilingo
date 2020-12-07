//
//  WordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct WordView: View {
    //var text: String?
    var word: identifiable_word?
    var isBased: Bool = false
    var onEnded: ((DragGesture.Value, UUID, String) -> Bool)?
    var onLongTap: ((String?) -> Void)?
    
    var computedWidth: CGFloat {
        guard let text = word?.text else { return 60 }
        let width = 52 + (text.count * 9)
        return CGFloat(width)
    }
    
    var computedFontSize: CGFloat {
        guard let text = word?.text else { return 30 }
        if text.count > 8 {
            return 24
        }
        if text.count > 6 {
            return 27
        }
        return 30
    }
    
    var text: String? {
        if word != nil {
            return word?.text
        }
        return nil
    }
    
    @State private var offset = CGSize.zero
    @State private var opacity = 1.0
    
    
    var body: some View {
        HStack(spacing: 0) {
            Image( self.text != nil ? "fish_head2" : "fish_head_g2")
                .resizable()
                .interpolation(.medium)
                .frame(width: 45, height: 45, alignment: .center)
                    //.offset(x: 2.5)
                .zIndex(0)
            
            ZStack {
               
                Rectangle()
                    .foregroundColor(self.text != nil ? Color(hex: "#585ea8") : Color(hex: "#909090"))
                    .frame(width: computedWidth, height: 45, alignment: .center)
                
                Text(word?.text.uppercased() ?? "...")
                    .font(Font.custom("boomboom", size: computedFontSize))
                    .foregroundColor(.white)
                    .frame(height: 45, alignment: .center)
            }
            .zIndex(1)
            
            Image(self.text != nil ? "fish_tail" : "fish_tail_g")
                .resizable()
                .interpolation(.high)
                .frame(width: 45, height: 45, alignment: .center)
                .offset(x: -1.5)
                .zIndex(0)
            
        }
        .onLongPressGesture {
           
                (onLongTap ?? { _ in })(self.text)
            
        }
        .drawingGroup()
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged({ value in
                    if isBased || text == nil { return }
                    self.offset = value.translation
                })
                .onEnded({ value in
                    let isSetted = (onEnded ?? { _,_,_ in return false })(value, word?.id ?? UUID() ,text ?? "")
            
                    
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
        WordView(word: identifiable_word("knowed"))
    }
}
