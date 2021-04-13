//
//  HomeView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    /// Gerekli tüm ViewModel'leri bağlıyorum:
    @StateObject var viewModel = HomeViewModel()
    @StateObject var asilarimViewModel = MyVaccinesViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    @StateObject var requestViewModel = FriendRequestViewModel()
    
    /// App Delegate'te kullanıcı giriş yaptıktan sonra UserDefaults'a kaydettiğimiz kullanıcı ID Token ve GoogleID bu değişkenler sayesinde alabiliyorum. (@AppStorege)
    @AppStorage("idToken") var idToken = ""
    @AppStorage("userID") var userID = ""
    
    /// Arkadaşlık isteklerini görünütülemek için Bool değişkeni
    @State var show = false
    
    /// Çıkış yapınca LoginView()'a gitmek için FullScreen modal değişkeni
    @State var isPresented = false
    
    // Button Titles:
    @State var asilarimButtonTittle = "Aşılarım"
    @State var arkadalarimButtonTittle = "Arkadaşlarım"
    @State var QRscanButtonTittle = "QR Scan"
    @State var QRgenerateButtonTittle = "QR Generate"
    
    var body: some View {
        
        /// NavigationView olmadan görünümler arası geçiş yapamayız. UIKit teki karşığı NavController ve Segue
        NavigationView{
            
           
            ZStack{
                NavigationLink("", destination: AsilarimView(homeViewModel : viewModel, viewModel: asilarimViewModel), isActive: $viewModel.nav1)
                NavigationLink("", destination: ArkadaslarimView(homeViewModel : viewModel, viewModel: friendsViewModel, requestModel: requestViewModel), isActive: $viewModel.nav2)
                NavigationLink("", destination: ScannerView(homeViewModel: viewModel), isActive: $viewModel.nav3)
                NavigationLink("", destination: QRGenerateView(homeViewModel : viewModel, vaccinesModel: asilarimViewModel), isActive: $viewModel.nav4)
                    
                
                VStack(spacing:25){
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
                }
                .padding(.horizontal, 15)
            }
            .navigationBarTitle("Ana Sayfa")
            .navigationBarTitleDisplayMode(.large)
            /// Bu görünüm her göründüğünde çağırılacak fonksiyonlar
            .onAppear(perform: {
                self.asilarimViewModel.fetchJSON()
                self.friendsViewModel.fetchJSON()
                self.requestViewModel.fetchJSON()
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
                                                }
                                            }
                                        }, label: {
                                            Text("Çıkış")
                                        }))
            .fullScreenCover(isPresented: $viewModel.loginView, content: LoginView.init)
            .sheet(isPresented: $show){
                FriendRequestView(viewModel: self.requestViewModel, friendModel: friendsViewModel)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
