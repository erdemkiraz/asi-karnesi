//
//  AsilarimViewModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import Foundation
import Combine

class AsilarimViewModel: ObservableObject {
    
    @Published var vaccineModel = [DetailedVaccineModel]()
    
    func fetchJSON(completion: @escaping (Bool) -> Void){
        
        // Gerçek fonksiyon:
        // Uygulamayı çalıştırmadan önce 26-68 aralığındaki satırları yorum satırı haline getiriniz veya siliniz.
        self.decodeJSON { (result) in
            if result == true {
                print("Success fetching JSON")
            }
        }
        
        // Test için JSON: [1]
        let jsonString = """
        [{
            "id": 0,
            "name": "COVID-19",
            "date": "15.02.2019",
            "dose": "1",
            "vaccine_point": "Ankara Merkez",
            "expires_in": "364"
        },
        {
            "id": 1,
            "name": "COVID-20",
            "date": "16.02.2019",
            "dose": "2",
            "vaccine_point": "İstanbul Merkez",
            "expires_in": "100"
        },
        {
            "id": 2,
            "name": "COVID-21",
            "date": "17.02.2019",
            "dose": "1",
            "vaccine_point": "İzmir Merkez",
            "expires_in": "354"
        }]
        """
        
        // JSON Decoder test işlemi (Veritabanından çekmek için bu kullanılmayacak): [2]
        if let jsonData = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode([DetailedVaccineModel].self, from: jsonData)
                DispatchQueue.main.async {
                    self.vaccineModel = user
                    completion(true)
                }
            } catch {
                print("error 1")
            }
        }  else {
            print("error 2")
        }
    }
    
    // Kullanılacak olan fonksiyon bu:
    // Bu fonksiyon üstteki fetchJSON() fonksiyonunun içerisine ekledim fakat yorum satırı haline getirdim.
    // Tkimatları yukarıda açıkladım.
    func decodeJSON(completion: @escaping (Bool) -> Void){
        
        // 1 - Decoding edilecek JSON URL:
        let url = URL(string: "www.example.com")!
        
        // 2 - JSONDecoder:
        let decoder = JSONDecoder()
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let vaccines = data {
                    do {
                        let user = try decoder.decode([DetailedVaccineModel].self, from: vaccines)
                        DispatchQueue.main.async {
                            self.vaccineModel = user // -> DetailedVaccineModel isimli modelden oluşan vaccineModel dizisine ekliyorum.
                            completion(true)
                        }
                    } catch {
                        print("catch error")
                    }
                } else {
                    print(error?.localizedDescription ?? "error")
                }
                
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }.resume()
    }
}
