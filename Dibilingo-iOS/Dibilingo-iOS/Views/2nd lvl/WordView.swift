//
//  WordView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct WordView: View {
    //var text: String?
    var word: words_for_verbs?
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
            //if text != nil {
            Image( self.text != nil ? "fish_head" : "fish_head_g")
                    .resizable()
                    //.transition(.opacity)
                    //.transition()
                    .frame(width: 45, height: 45, alignment: .center)
                    .offset(x: 2.5)
                    .zIndex(0)
            //}
            ZStack {
                //RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                Rectangle()
                    .foregroundColor(self.text != nil ? Color(hex: "#585ea8") : Color(hex: "#909090"))
                    //.frame(height: 45, alignment: .center)
                    //.animation(.easeIn(duration: 0.1))
                    .frame(width: computedWidth-2.5, height: 45, alignment: .center)
                
                Text(word?.text.uppercased() ?? "...")
                    .font(Font.custom("boomboom", size: computedFontSize))
                    .foregroundColor(.white)
                    .frame(height: 45, alignment: .center)
            }
            .zIndex(1)
            //.frame(width: computedWidth, height: 45, alignment: .center)
            //.onLongPressGesture {
            //    (onLongTap ?? { _ in })(self.text)
           // }
            //if text != nil {
            Image(self.text != nil ? "fish_tail" : "fish_tail_g")
                    .resizable()
                    //.transition(.opacity)
                    .frame(width: 45, height: 45, alignment: .center)
                    .offset(x: -1.5)
                    .zIndex(0)
            //}
        }
        .onLongPressGesture {
            //withAnimation(.easeIn(duration: 0.1), { self.opacity = 0.0 })
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                //withAnimation(.easeIn(duration: 0.5), { isPointUp = false })
            

                (onLongTap ?? { _ in })(self.text)
                
               // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               //     withAnimation(.easeIn(duration: 0.1), { self.opacity = 1.0 })
                //}
            //}
            
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
        return WordView(word: words_for_verbs("knowed"))
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
                //.frame(width: 20, height: 45, alignment: .center)
            Text("WW")
                .font(Font.custom("boomboom", size: 30))
        }
        .frame(width: 51, height: 45, alignment: .center)
    }
}
