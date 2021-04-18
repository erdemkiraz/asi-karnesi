//
//  HomeView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI
import FirebaseAuth
import UIKit
import UserNotifications

struct HomeView: View {
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    /// Gerekli tüm ViewModel'leri bağlıyorum:
    @StateObject var viewModel = HomeViewModel()
    @StateObject var asilarimViewModel = MyVaccinesViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    @StateObject var requestViewModel = FriendRequestViewModel()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var googleViewModel = GoogleContactsViewModel()
    
    /// App Delegate'te kullanıcı giriş yaptıktan sonra UserDefaults'a kaydettiğimiz kullanıcı ID Token ve GoogleID bu değişkenler sayesinde alabiliyorum. (@AppStorage)
    @AppStorage("idToken") var idToken = ""
    @AppStorage("userID") var userID = ""
    @AppStorage("email") var email = ""
    @AppStorage("name") var name = ""
    @AppStorage("accessToken") var accessToken = ""
    
    /// Arkadaşlık isteklerini görünütülemek için Bool değişkeni
    @State var show = false
    
    /// Çıkış yapınca LoginView()'a gitmek için FullScreen modal değişkeni
    @State var isPresented = false
    
    // Button Titles:
    @State var asilarimButtonTittle = "Aşılarım"
    @State var arkadalarimButtonTittle = "Arkadaşlarım"
    @State var QRscanButtonTittle = "QR Scan"
    @State var QRgenerateButtonTittle = "QR Generate"
    
    /// Profile:
    @State var showProfile = false
    
    /// Google Contacts:
    @State var showContacts = false
    
    var body: some View {
        
        /// NavigationView olmadan görünümler arası geçiş yapamayız. UIKit teki karşığı NavController ve Segue
        NavigationView{
            
            /*
             ZStack -> ZStack bloğu içerisine konulan her şey üst üste gelir. En yukarıdaki satır en arkada en alttaki satır en üste.
             VStack -> Vertical Stack içerisindeki her şeyi alt alta koyar.
             HStack -> Horizontal Stack içerisindeki her şeyi yan yana koyar.
             
             NOT: ZStack içerisindeki herhangi bir görünümün üstte mi  altta mı olacağına .zIndex(Int) ile belirleyebiliriz.
             */
            ZStack{
                NavigationLink("", destination: AsilarimView(homeViewModel : viewModel, viewModel: asilarimViewModel), isActive: $viewModel.nav1)
                NavigationLink("", destination: ArkadaslarimView(homeViewModel : viewModel, viewModel: friendsViewModel, requestModel: requestViewModel), isActive: $viewModel.nav2)
                NavigationLink("", destination: ScannerView(homeViewModel: viewModel), isActive: $viewModel.nav3)
                NavigationLink("", destination: QRGenerateView(homeViewModel : viewModel, vaccinesModel: asilarimViewModel), isActive: $viewModel.nav4)
                NavigationLink("", destination: LoginView(), isActive: $isPresented)
                NavigationLink("", destination: ProfileView(viewModel: userViewModel), isActive: $showProfile)
                NavigationLink("", destination: GoogleContactsView(viewModel: googleViewModel), isActive: $showContacts)
                
                VStack(spacing:25){
                    VStack(alignment: .leading){
                        
                        if let data = self.userViewModel.userData?.info {
                            HStack(spacing:0){
                                Text("Merhaba ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .medium, design: .default))
                                Text("\(data.name)!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold, design: .default))
                            }
                            .padding(.top, 25)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    
                    
                    HStack(spacing: 25){
                        
                        /// Aşılarım Butonu
                        Button(action: {
                                self.viewModel.asilarButton()
                        }, label: {
                            HomeViewButtonsView(title: self.asilarimButtonTittle)
                        })
                        
                        /// Arkadaşlarım Butonu
                        Button(action: {
                            self.viewModel.arkadaslarimButton()
                            
                        }, label: {
                            HomeViewButtonsView(title: self.arkadalarimButtonTittle)
                        })
                    }
                    
                    HStack(spacing:25){
                        
                        /// QR Okuyucu Butonu
                        Button(action: {
                            self.viewModel.qrScanButton()
                        }, label: {
                            HomeViewButtonsView(title: self.QRscanButtonTittle)
                        })
                        
                        /// QR Yaratma Butonu
                        Button(action: {
                            self.viewModel.qrGenerateButton()
                        }, label: {
                            HomeViewButtonsView(title: self.QRgenerateButtonTittle)
                        })
                    }
                    Button {
                        self.showContacts = true
                    } label: {
                        ZStack{
                            Color.purple
                                .cornerRadius(15)
                                .frame(height: 100, alignment: .center)
                            Text("Google Contacts")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                    }

                    Spacer()
                    Button {
                        self.showProfile = true
                    } label: {
                        VStack(spacing:0){
                            Image(systemName: "person.crop.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            Text("Profil")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal, 30)
                        .background(Color.purple.cornerRadius(15))
                    }

                    
                }
                .padding(.horizontal, 15)
            }
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            /// Bu görünüm her göründüğünde çağırılacak fonksiyonlar
            .onAppear(perform: {
                self.asilarimViewModel.fetchJSON(googleID: self.userID)
                
                self.friendsViewModel.fetchJSON(googleID: self.userID)
                
                self.requestViewModel.fetchJSON(googleID: self.userID)
                
                self.userViewModel.fetchJSON(googleID: self.userID)
                
                self.googleViewModel.fetchJSON(googleID: self.userID)
                
                print("Current User: \(self.email)")
                print(self.userID)
            })
            /// Çıkış yapma butonu:
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.show = true
                                    }, label: {
                                        Text("Arkadaş istekleri")
                                    }), trailing:
                                        
                                        Button(action: {
                                            self.viewModel.signOutButton { (result) in
                                                if result == true {
                                                    self.idToken = ""
                                                    self.userID = ""
                                                    self.email = ""
                                                    self.name = ""
                                                    self.accessToken = ""
                                                    self.isPresented = true
                                                    
                                                }
                                            }
                                        }, label: {
                                            Text("Çıkış")
                                        }))
            .sheet(isPresented: $show){
                FriendRequestView(viewModel: self.requestViewModel, friendModel: friendsViewModel)
            }
            .onReceive(timer) { input in
                self.requestViewModel.fetchJSON(googleID: self.userID)
                if self.requestViewModel.friendModel.isEmpty == true {
                    print("Arakdaşlık isteği Yok")
                } else {
                    print("İSTEK GELDİ!!!!!!!!!!--------!!!!!!!!!!!!!!!!!!!!!")
                    var name = ""
                    let label = "Sana arkadaşlık isteği gönderdi"
                    for data in self.requestViewModel.friendModel {
                        name = data.requester_name
                    }
                    // second
                    let content = UNMutableNotificationContent()
                    content.title = "\(name) \(label)"
                    content.sound = UNNotificationSound.default

                    // show this notification five seconds from now
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    // choose a random identifier
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
    }
}
