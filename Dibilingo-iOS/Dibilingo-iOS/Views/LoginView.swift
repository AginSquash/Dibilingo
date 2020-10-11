//
//  LoginView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 25.09.2020.
//

import SwiftUI

let serverURL = "http://192.168.88.133:5000"

struct LoginView: View {
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State private var downloadedImages: Int = 0
    @State private var totalImages: Int = 0
    
    @State private var username: String = ""
    
    @State private var userAlreadyExist = false
    @State private var isUpdated = false
    
    var isEnableRegister: Bool {
       return (totalImages == downloadedImages) && (username.count > 3)
    }
    
    @State private var pushToMain = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // background
                
                    NavigationLink(
                        destination: ContentView().navigationBarHidden(true),
                        isActive: $pushToMain,
                        label: { })
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Loading:")
                            .font(Font.custom("boomboom", size: 26))
                        Text("\(downloadedImages)/\(totalImages)")
                            .font(Font.custom("Coiny", size: 26))
                    }
                }.zIndex(1)
                
                if !userAlreadyExist {
                    VStack {
                        Text("Your name:")
                            .font(Font.custom("boomboom", size: 32))
                        
                        TextField("name", text: $username)
                            .font(Font.custom("boomboom", size: 38))
                            .multilineTextAlignment(.center)
                            .padding([.bottom, .top])
                            
                        Button(action: register, label: {
                            Text("Sign up")
                                .font(Font.custom("boomboom", size: 32))
                                .foregroundColor( !isEnableRegister ? Color.gray : Color.init(hex: "#87ff6d") )
                        })
                        .disabled(!isEnableRegister)
                    }.zIndex(2)
                } else {
                    VStack {
                        Text("Dear, \(username)")
                            .font(Font.custom("boomboom", size: 32))
                            .padding(.bottom)
                        Text("Please, wait for updating...")
                            .font(Font.custom("boomboom", size: 32))
                            NavigationLink(
                                destination: ContentView().navigationBarHidden(true),
                                isActive: $isUpdated,
                                label: { })
                    }.zIndex(2)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear(perform: loadData)
        //.onAppear(perform: checkData)
    }
    
    func checkData() {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let url = baseURL
        var files = [URL]()
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                } catch { print(error, fileURL) }
            }
            print(files)
        }  //Perform any operation you want by using its path
        
        let data = try? Data(contentsOf: baseURL.appendingPathComponent("CardsList"))
        if let data = data {
            let decoded = try? JSONDecoder().decode(CardList.self, from: data)
            print(decoded)
        }
    }
    
    func loadData() {
        guard let dataVersionURL = URL(string: "\(serverURL)/dibilingo/api/v1.0/datahash") else { return }
        guard let url = URL(string: "\(serverURL)/dibilingo/api/v1.0/cardlist") else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let upEncoded = try? Data(contentsOf: baseURL.appendingPathComponent("UserProfile")) {
                if let up = try? JSONDecoder().decode(UserProfile.self, from: upEncoded) {
                    DispatchQueue.main.async {
                        self.username = up.name
                        self.userAlreadyExist = true
                    }
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            //loading data version
            URLSession.shared.dataTask(with: dataVersionURL) { data, responce, error in
                if let data = data {
                    if let _ = try? JSONDecoder().decode(DataVersion.self, from: data) {
                        try? data.write(to: baseURL.appendingPathComponent("DataVersion"))
                    }
                }
                
            }.resume()
            
            // Load json with cards-name
            URLSession.shared.dataTask(with: url) { data_cl_s, response, error in
                
                if let response = response {
                    //print(response)
                }
                
                if let data_cl = data_cl_s {
                    let cardsList_server = try? JSONDecoder().decode(CardList_server.self, from: data_cl)
                
                    // Load cards
                    if let cardsList_server = cardsList_server {
                        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let cl = CardList(cl_s: cardsList_server)
                        do {
                            let data_cl = try JSONEncoder().encode(cl)
                            try data_cl.write(to: baseURL.appendingPathComponent("CardsList"))
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        DispatchQueue.main.async {
                            self.totalImages = cl.new_cards.count
                        }
                        
                        for card in cl.new_cards {
                            guard let url = URL(string: "\(serverURL)/dibilingo/api/v1.0/image/\(card)/") else { return }
                            
                            URLSession.shared.dataTask(with: url) { imageData, response, error in
                                
                                if let response = response {
                                    //print(response)
                                }
                                
                                if let imageData = imageData {
                                    if imageData.count > 0 {
                                        print(imageData)
                                        do {
                                            try imageData.write(to: baseURL.appendingPathComponent("\(card).jpg"))
                                            
                                            DispatchQueue.main.async {
                                                self.downloadedImages += 1
                                                if self.totalImages == self.downloadedImages {
                                                    self.isUpdated = true
                                                }
                                            }

                                            
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    } else {
                                        
                                        DispatchQueue.main.async {
                                            self.totalImages -= 1
                                            if self.totalImages == self.downloadedImages {
                                                self.isUpdated = true
                                            }
                                        }
                                        
                                        print("DEBUG: incorrect data with \(card)")
                                        var newCL = cl
                                        newCL.new_cards.removeAll(where: { $0 == card })
                                        if let encoded = try? JSONEncoder().encode(newCL) {
                                            do {
                                                try encoded.write(to: baseURL.appendingPathComponent("CardsList"))
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                                
                            }.resume()
                        }
                        

                    }
                }
                
            }.resume()
        }
    }
    
    func register() {
        let name = username
        // here must be user register on server
        
        let newUP = UserProfile(id: UUID().uuidString, name: name, coins: 0)
        
        if let encoded = try? JSONEncoder().encode(newUP) {
            if let succefullWrited = try? encoded.write(to: baseURL.appendingPathComponent("UserProfile"), options: .atomic) {
                self.pushToMain = true
                return
            }
        }
        fatalError("Cannot register")
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
