//
//  HomeViewModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var nav1 = false
    @Published var nav2 = false
    @Published var nav3 = false
    @Published var nav4 = false
    
    func asilarButton(){
        self.nav1 = true
    }
    
    func arkadaslarimButton(){
        self.nav2 = true
    }
    
    func qrScanButton(){
        self.nav3 = true
    }
    
    func qrGenerateButton(){
        self.nav4 = true
    }
    
}
