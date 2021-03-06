//
//  LoginView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 25.09.2020.
//

import SwiftUI

#if targetEnvironment(simulator)
let serverURL = "http://127.0.0.1:5000"
#else
//let serverURL = "http://192.168.88.32:5000"
let serverURL = "http://192.168.43.82:5000"
#endif

struct LoginView: View {
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State private var downloadedImages: Int = 0
    @State private var totalImages: Int = 0
    
    @State private var username: String = ""
    
    @State private var userAlreadyExist = false
    @State private var isUpdated = false
    
    @State private var showError: Bool = false
    
    var isEnableRegister: Bool {
       return (totalImages == downloadedImages) && (username.count > 3)
    }
    
    @State private var pushToMain = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Image(decorative: "login")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                   // .edgesIgnoringSafeArea(.top)
                    .zIndex(-1)
                
                NavigationLink(
                    destination: MainmenuView().navigationBarHidden(true),
                    isActive: $pushToMain,
                    label: { })
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Загрузка:")
                            .font(Font.custom("boomboom", size: 26))
                        Text("\(downloadedImages)/\(totalImages)")
                            .font(Font.custom("Coiny", size: 26))
                    }
                    .foregroundColor(Color(hex: "#004157"))
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white)
                            .frame(width: 225, height: 50, alignment: .center)
                            .shadow(radius: 5)
                    )
                }.zIndex(1)
                
                if !userAlreadyExist {
                    VStack {
                        Text("Ваше имя:")
                            .foregroundColor(Color(hex: "#004157"))
                            .font(Font.custom("boomboom", size: 32))
                            .offset(y: 5)
                        
                        TextField("Имя", text: $username)
                            .font(Font.custom("boomboom", size: 38))
                            .foregroundColor(Color(hex: "#42748c"))
                            .multilineTextAlignment(.center)
                            .offset(y: 5)
                            .padding([.bottom, .top])
                            
                        Button(action: register, label: {
                            Image( !isEnableRegister ? "arrow_next_g" : "arrow_next")
                                .resizable()
                                .frame(width: 65, height: 40, alignment: .center)
                                //.font(Font.custom("boomboom", size: 32))
                                .foregroundColor( !isEnableRegister ? Color.gray : Color.init(hex: "#87ff6d") )
                        })
                        .disabled(!isEnableRegister)
                    }
                    .zIndex(2)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 200, alignment: .center)
                            .shadow(radius: 5)
                    )
                } else {
                    VStack {
                        Text("Dear, \(username)")
                            .font(Font.custom("boomboom", size: 32))
                            .padding(.bottom)
                        Text("Пожалуйста, дождитесь обновления...")
                            .font(Font.custom("boomboom", size: 32))
                            NavigationLink(
                                destination: MainmenuView().navigationBarHidden(true),
                                isActive: $isUpdated,
                                label: { })
                    }.zIndex(2)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white)
                            .frame(width: 390, height: 150, alignment: .center)
                            .shadow(radius: 5)
                    )
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showError) {
                Alert(title: Text("Ошибка"), message: Text("Введите имя на англиском"), dismissButton: .default(Text("Ok"), action: { self.username = "" }))
            }
        }
        .onAppear(perform: loadData)
        .navigationViewStyle(StackNavigationViewStyle())
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
        }
        
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
            if let userprofile = getUserProfile() {
                DispatchQueue.main.async {
                    self.username = userprofile.name
                    self.userAlreadyExist = true
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Loading data version
            URLSession.shared.dataTask(with: dataVersionURL) { data, responce, error in
                if let data = data {
                    if let _ = try? JSONDecoder().decode(DataVersion.self, from: data) {
                        try? data.write(to: baseURL.appendingPathComponent("DataVersion"))
                    }
                }
                
            }.resume()
            
            
            // Loading verbs json
            URLSession.shared.dataTask(with: URL(string: "\(serverURL)/dibilingo/api/v1.0/verbs")!) { data, responce, error in
                if let data = data {
                    if let _ = try? JSONDecoder().decode([IrregVerb].self, from: data) {
                        try? data.write(to: baseURL.appendingPathComponent("IrregVerb.json"))
                        print("SAVED: IrregVerb.json")
                    }
                }
                
            }.resume()
            
            // Loading verbs json
            URLSession.shared.dataTask(with: URL(string: "\(serverURL)/dibilingo/api/v1.0/sentences")!) { data, responce, error in
                if let data = data {
                    if let _ = try? JSONDecoder().decode(sentencesAll.self, from: data) {
                        try? data.write(to: baseURL.appendingPathComponent("sentences.json"))
                        print("SAVED: sentences.json")
                    }
                }
                
            }.resume()
            
            // Load json with cards-name
            URLSession.shared.dataTask(with: url) { data_cl_s, response, error in
                
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
        var name = username
        // here must be user register on server
        //name = name.replacingOccurrences(of: " ", with: "_")
        //name = name.replacingOccurrences(of: "/", with: "")
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if name.rangeOfCharacter(from: characterset.inverted) != nil {
            self.showError = true
            return
        }
        
        URLSession.shared.dataTask(with: URL(string: "\(serverURL)/dibilingo/api/v1.0/login/\(name)/")! ) { data, response, error in
            
            if let data = data {
                print("DATA NOT NIL!")
                let decoded = try? JSONDecoder().decode(UserProfile.self, from: data)
                if decoded != nil{
                    print("DATA OK!")
                    print(decoded)
                    if let succefullWrited = try? data.write(to: baseURL.appendingPathComponent("UserProfile"), options: .atomic) {
                        self.pushToMain = true
                        return
                    }
                }
            }
            
        }.resume()
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
