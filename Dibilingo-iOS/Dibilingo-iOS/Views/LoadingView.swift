//
//  LoadingView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 11.10.2020.
//

import SwiftUI

struct LoadingView: View {
    @State private var toLoginView = false
    @State private var toContentView = false
    @State private var continueWithOutInternet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                NavigationLink(
                    destination: LoginView().navigationBarHidden(true),
                    isActive: $toLoginView,
                    label: { })
                
                NavigationLink(
                    destination: ContentView().navigationBarHidden(true),
                    isActive: $toContentView,
                    label: { })
                
                VStack {
                    Spacer()
                    Text("Connecting...")
                        .font(Font.custom("boomboom", size: 26))
                    
                    Spacer()
                    if continueWithOutInternet {
                        NavigationLink(
                            destination: ContentView().navigationBarHidden(true),
                            label: {
                                Text("Continue Without Internet")
                            })
                            .transition(.opacity)
                            .padding(.bottom)
                    }
                }
            }.navigationBarHidden(true)
        }.onAppear(perform: checkData)
    }
    
    func checkData() {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
       
        guard let dataVersionURL = URL(string: "\(serverURL)/dibilingo/api/v1.0/datahash") else { return }
        
        var timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            print("No internet")
            
            guard let dvData = try? Data(contentsOf: baseURL.appendingPathComponent("DataVersion")) else { return }
            guard let dvFromDisk = try? JSONDecoder().decode(DataVersion.self, from: dvData) else { return }
            
            if dvFromDisk.dataHash.isEmpty == false {
                withAnimation { self.continueWithOutInternet = true }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            func setLinkView(setContentView: Bool = false) {
                DispatchQueue.main.async {
                    if setContentView {
                        toContentView = true
                    } else { toLoginView = true }
                }
            }
            
            guard let dvData = try? Data(contentsOf: baseURL.appendingPathComponent("DataVersion")) else { setLinkView(); return }
            guard let dvFromDisk = try? JSONDecoder().decode(DataVersion.self, from: dvData) else { setLinkView(); return }
            //loading data version
            URLSession.shared.dataTask(with: dataVersionURL) { data, responce, error in
                if let data = data {
                    timer.invalidate()
                    if let dv = try? JSONDecoder().decode(DataVersion.self, from: data) {
                        if dv.dataHash == dvFromDisk.dataHash {
                            if let _ = try? Data(contentsOf: baseURL.appendingPathComponent("UserProfile")) {
                                setLinkView(setContentView: true)
                                return
                            }
                        }
                    }
                } else {
                    print("No data")
                    return
                }
            }.resume()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
