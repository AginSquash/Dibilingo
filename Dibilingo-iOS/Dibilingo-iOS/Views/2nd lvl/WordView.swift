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
        let width = 40 + (text.count * 10)
        return CGFloat(width)
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
            //}
            ZStack {
                //RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                Rectangle()
                    .foregroundColor(self.text != nil ? Color(hex: "#585ea8") : Color(hex: "#909090"))
                    .frame(height: 45, alignment: .center)
                    //.animation(.easeIn(duration: 0.1))
                
                Text(text?.uppercased() ?? "...")
                    .font(Font.custom("boomboom", size: 29))
                    .foregroundColor(.white)
            }
            .frame(width: computedWidth, height: 45, alignment: .center)
            //.onLongPressGesture {
            //    (onLongTap ?? { _ in })(self.text)
           // }
            //if text != nil {
            Image(self.text != nil ? "fish_tail" : "fish_tail_g")
                    .resizable()
                    //.transition(.opacity)
                    .frame(width: 45, height: 45, alignment: .center)
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
        WordView(text: "shakeing")
    }
}
