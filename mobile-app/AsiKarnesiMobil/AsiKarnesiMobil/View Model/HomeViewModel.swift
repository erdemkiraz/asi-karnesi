//
//  HomeViewModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 5.04.2021.
//

import Foundation
import FirebaseAuth

class HomeViewModel: ObservableObject {
    
    /// Navigasyon Değişkenleri
    @Published var nav1 = false
    @Published var nav2 = false
    @Published var nav3 = false
    @Published var nav4 = false
    
    @Published var loginView = false
    
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
    
    /// Çıkış Yapma Fonkisyonu
    func signOutButton(completion: @escaping (Bool) -> Void){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.loginView = true
            completion(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
