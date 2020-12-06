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
    @State private var currentBackground = "loading_morning"
    @State private var userprofile: UserProfile?
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Image(decorative: currentBackground)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                NavigationLink(
                    destination: LoginView().navigationBarHidden(true),
                    isActive: $toLoginView,
                    label: { })
                
                NavigationLink(
                    destination: MainmenuView().navigationBarHidden(true),
                    isActive: $toContentView,
                    label: { })
                
                VStack {
                    Spacer()
                    Text("Connecting")
                        .font(Font.custom("boomboom", size: 26))
                        .foregroundColor(.white)
                    
                    Spacer()
                    if continueWithOutInternet {
                        NavigationLink(
                            destination: MainmenuView().navigationBarHidden(true),
                            label: {
                                Text("Continue Without Internet")
                            })
                            .transition(.opacity)
                            .padding(.bottom)
                    }
                }
            }.navigationBarHidden(true)
        }.onAppear(perform: screenLoad)
    }
    
    func screenLoad() {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if (hour >= 5) && (hour <= 9) { currentBackground = "loading_morning" }
        if (hour > 9) && (hour <= 18) { currentBackground = "loading_day" }
        if (hour > 18) || (hour < 5) { currentBackground = "loading_evening" }
        
        checkData()
    }
    
    func checkData() {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
       
        guard let dataVersionURL = URL(string: "\(serverURL)/dibilingo/api/v1.0/datahash") else { return }
        
        var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
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
                    
                    // check for data version
                    if let dv = try? JSONDecoder().decode(DataVersion.self, from: data) {
                        if dv.dataHash == dvFromDisk.dataHash {
                            
                            // if dataHash updated check userprofile for update
                            // loading from disk
                            if let up_decoded = getUserProfile() {
                                
                                    // loading from server
                                    URLSession.shared.dataTask(with: URL(string: "\(serverURL)/dibilingo/api/v1.0/login/\(up_decoded.name)/")! ) { data, response, error in
                                        
                                        if let data = data {
                                            print("DATA NOT NIL!")
                                            let decoded = try? JSONDecoder().decode(UserProfile.self, from: data)
                                            if let new_up = decoded {
                                                
                                                if up_decoded < new_up { // we have newer version on server
                                                    let data_write_result = try? data.write(to: baseURL.appendingPathComponent("UserProfile"), options: .atomic)
                                                    if data_write_result != nil {
                                                        print("UPDATED!")
                                                        setLinkView(setContentView: true)
                                                        return
                                                    }
                                                } else { // no need update
                                                    print("Already updated")
                                                    setLinkView(setContentView: true)
                                                    return
                                                }
                                                
                                            }
                                        }
                                        
                                    }.resume()
                                    // return?
                            } else { setLinkView(); return }
                        } else { setLinkView(); return }
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
