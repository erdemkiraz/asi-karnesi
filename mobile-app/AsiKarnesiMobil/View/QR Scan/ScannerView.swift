//
//  ScannerView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import SwiftUI

struct ScannerView: View {
    
    @ObservedObject var viewModel = ScannerViewModel()
    @ObservedObject var homeViewModel : HomeViewModel
    
    @State var goDetails = false
    
    var body: some View {
        ZStack {
            NavigationLink("", destination: ScannedVaccinesView(viewModel: viewModel), isActive: $goDetails)
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)
                .ignoresSafeArea()
            VStack{
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                    .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
                Spacer()
            }
            .ignoresSafeArea()
            Image(systemName: "viewfinder")
                .foregroundColor(self.viewModel.lastQrCode == "" ? Color.white.opacity(0.4) : Color.green.opacity(0.9))
                .font(.system(size: 350, weight: .thin, design: .default))
                
            VStack(alignment: .leading){
                Button {
                    self.homeViewModel.nav3 = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold, design: .default))
                }
                
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.top, 10)
            VStack {
                VStack {
                    Text("QR kodu tara")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    Text(self.viewModel.lastQrCode)
                        .foregroundColor(Color.green)
                        .bold()
                        .lineLimit(5)
                        .padding()
                }
                .padding(.vertical, 15)
                Spacer()
                HStack {
                    Button(action: {
                        self.viewModel.torchIsOn.toggle()
                    }, label: {
                        Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                            .padding()
                    })
                }
                .background(Color.white)
                .cornerRadius(10)
                
            }.padding(.bottom)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: self.viewModel.lastQrCode) { (Equatable) in
            self.viewModel.qrGet { (result) in
                if result{
                    self.goDetails = true
                }
            }
        }
    }
}
