//
//  HomeView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject var asilarimViewModel = AsilarimViewModel()
    
    // Button Titles:
    @State var asilarimButtonTittle = "Aşılarım"
    @State var arkadalarimButtonTittle = "Arkadaşlarım"
    @State var QRscanButtonTittle = "QR Scan"
    @State var QRgenerateButtonTittle = "QR Generate"
    
    var body: some View {
        NavigationView{
            ZStack{
                NavigationLink("", destination: AsilarimView(homeViewModel : viewModel, viewModel: asilarimViewModel), isActive: $viewModel.nav1)
                NavigationLink("", destination: ArkadaslarimView(homeViewModel : viewModel), isActive: $viewModel.nav2)
                NavigationLink("", destination: QRScanView(homeViewModel : viewModel), isActive: $viewModel.nav3)
                NavigationLink("", destination: QRGenerateView(homeViewModel : viewModel), isActive: $viewModel.nav4)
                VStack(spacing:25){
                    HStack(spacing: 25){
                        Button(action: {
                            self.asilarimViewModel.fetchJSON { (result) in
                                if result == true {
                                    self.viewModel.nav1 = true
                                }
                            }
                        }, label: {
                            HomeViewButtonsView(title: self.asilarimButtonTittle)
                        })
                        Button(action: {
                            self.viewModel.nav2 = true
                        }, label: {
                            HomeViewButtonsView(title: self.arkadalarimButtonTittle)
                        })
                    }
                    
                    HStack(spacing:25){
                        Button(action: {
                            self.viewModel.nav3 = true
                        }, label: {
                            HomeViewButtonsView(title: self.QRscanButtonTittle)
                        })
                        Button(action: {
                            self.viewModel.nav4 = true
                        }, label: {
                            HomeViewButtonsView(title: self.QRgenerateButtonTittle)
                        })
                    }
                }
                .padding(.horizontal, 15)
            }
            .navigationBarTitle("Ana Sayfa")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
