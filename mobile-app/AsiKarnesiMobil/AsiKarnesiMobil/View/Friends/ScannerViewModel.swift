//
//  ScannerViewModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 8.04.2021.
//

import Foundation

class ScannerViewModel: ObservableObject {
    
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = ""
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = "QR Kod: \(code)"
    }
}


