//
//  LoginView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 25.09.2020.
//

import SwiftUI

let serverURL = "http://192.168.88.133:5000"

struct LoginView: View {
    @State private var downloadedImages: Int = 0
    @State private var totalImages: Int = 0
    
    @State private var username: String = ""
    
    var body: some View {
        ZStack {
            
            // background
            
            VStack {
                Spacer()
                Text("Loading: \(downloadedImages)/\(totalImages)")
                    .padding()
            }.zIndex(1)
            
            VStack {
                HStack {
                    Text("Your name:")
                        .frame(width: 100, height: 50, alignment: .center)
                    
                    TextField("name", text: $username)
                        .multilineTextAlignment(.center)
                        .frame(width: 175, height: 50, alignment: .center)
                        .padding([.bottom, .top])
                    
                    Spacer()
                        .frame(width: 100, height: 50, alignment: .center)
                      
                }
                Button("Sign up", action: {})
                    .disabled(downloadedImages != totalImages)
                    .padding()
            }.zIndex(2)
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
        guard let url = URL(string: "\(serverURL)/dibilingo/api/v1.0/cardlist") else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Load json with cards-name
            URLSession.shared.dataTask(with: url) { data_cl, response, error in
                
                if let response = response {
                    //print(response)
                }
                
                if let data_cl = data_cl {
                    let cardsList = try? JSONDecoder().decode(CardList.self, from: data_cl)
                
                    // Load cards
                    if let cardsList = cardsList {
                        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        do {
                            try data_cl.write(to: baseURL.appendingPathComponent("CardsList"))
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        DispatchQueue.main.async {
                            self.totalImages = cardsList.cards.count
                        }
                        
                        for card in cardsList.cards {
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
                                            }

                                            
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    } else {
                                        
                                        DispatchQueue.main.async {
                                            self.totalImages -= 1
                                        }
                                        
                                        print("DEBUG: incorrect data with \(card)")
                                        var newCL = cardsList
                                        newCL.cards.removeAll(where: { $0 == card })
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
