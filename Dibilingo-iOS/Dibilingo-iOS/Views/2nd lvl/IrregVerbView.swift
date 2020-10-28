//
//  IrregVerbView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct IrregVerbView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //background
                VStack {
                        Spacer()
                        HStack(alignment: .center, spacing: nil) {
                            Spacer()
                            WordView(text: "BEGIN")
                            Image(systemName: "arrow.right")
                                .font(.title)
                            WordView(text: "BEGAN")
                            Image(systemName: "arrow.right")
                                .font(.title)
                            WordView(text: "BEGUN")
                            Spacer()
                        }
                    
                    Spacer()
                }
                VStack {
                    Spacer()
                    PossibleWordsView(height: geo.size.height/3, words: ["begin", "begun", "began", "adsd", "forgot", "forgotten", "adaa" ])
                        .padding([.leading, .trailing])
                }
            }
        }
    }
}

struct IrregVerbView_Previews: PreviewProvider {
    static var previews: some View {
        IrregVerbView()
    }
}
