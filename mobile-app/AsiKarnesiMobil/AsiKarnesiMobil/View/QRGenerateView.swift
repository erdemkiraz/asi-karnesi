//
//  QRGenerateView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import SwiftUI

struct QRGenerateView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    
    
    var body: some View {
        ZStack{
            Text("QR Generate")
            
        }
        .navigationBarTitle("QR Generate")
    }
}

struct QRGenerateView_Previews: PreviewProvider {
    static var previews: some View {
        QRGenerateView(homeViewModel: HomeViewModel())
    }
}
