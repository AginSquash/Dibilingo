//
//  LoadingView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 11.10.2020.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Connecting...")
                    .font(Font.custom("boomboom", size: 26))
            }
        }.onAppear(perform: checkData)
    }
    
    func checkData() {
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
