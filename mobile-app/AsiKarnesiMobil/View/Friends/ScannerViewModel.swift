//
//  ScannerViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import Foundation

class ScannerViewModel: ObservableObject {
    
    let scanInterval: Double = 1.0
    
    @Published var data = [DetailedQrVaccinesModel]()
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = ""
    @Published var qrCodeLink = ""
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = "QR Kod: \(code)"
        self.qrCodeLink = code
    }
    

    
    func qrGet(completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(baseURL)/get-vaccinations-from-link?link=\(self.qrCodeLink)") else {return}
        
        //guard let url = URL(string: "http://127.0.0.1:5000/get-privacy?vaccination_id=2") else {return}
        
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(QrVaccinesModel.self, from: data)
                DispatchQueue.main.async {
                    self.data = rss.vaccinations
                    completion(true)
                }
            } catch {
                print("catch error")
            }
        }.resume()
    }
    
    
}


