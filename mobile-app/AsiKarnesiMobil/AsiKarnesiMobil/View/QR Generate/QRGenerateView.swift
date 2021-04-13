//
//  QRGenerateView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRGenerateView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    @ObservedObject var vaccinesModel : MyVaccinesViewModel
    
    @StateObject var viewModel = QrGenerateViewModel()
    
    /// GoogleID
    @AppStorage("userID") var userID = ""
    
    @State var show = false
    @State var showQR = false
    
    var body: some View {
        ZStack{
            VStack{
                Button {
                    self.show = true
                } label: {
                    Text("Aşıları Seç")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 50)
                        .background(Color.white.opacity(0.15).cornerRadius(15))
                }
                
                
                if self.viewModel.url != "" && self.showQR == true {
                    Image(uiImage: self.viewModel.generateQRCode(from: self.viewModel.url))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding(.top, 20)
                }
                Spacer()
                
                Text("QR Url: \(self.viewModel.url)")
                    .font(.system(size: 12, weight: .semibold, design: .default))
                
                Text("Seçilen Aşı Sayısı: \(self.viewModel.selectedVaccines.count)")
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .padding(.bottom,20)
                
                Button {
                    self.viewModel.sendPostJSON(userID: self.userID) { (result) in
                        if result == true {
                            // QR Generate
                            self.showQR = true
                        }
                    }
                } label: {
                    Text("QR Kod Oluştur")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 25)
                        .background(Color.green.cornerRadius(15))
                        .padding(.bottom, 15)
                        .opacity(self.viewModel.selectedVaccines.isEmpty ? 0.3 : 1)
                }
                .disabled(self.viewModel.selectedVaccines.isEmpty ? true : false)
            }
            .padding(.top, 20)
            
            
        }
        .navigationBarTitle("QR Generate")
        .sheet(isPresented: $show){
            SelectVaccinesView(myVaccinesViewModel: vaccinesModel, viewModel: viewModel)
        }
    }
}

