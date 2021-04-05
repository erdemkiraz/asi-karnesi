//
//  QRScanView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import SwiftUI

struct QRScanView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    
    var body: some View {
        ZStack{
            Text("QR Scan")
        }
        .navigationBarTitle("QR Scan")
    }
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView(homeViewModel : HomeViewModel())
    }
}
