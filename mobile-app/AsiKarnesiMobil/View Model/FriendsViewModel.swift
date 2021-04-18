//
//  FriendsViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import SwiftUI

class FriendsViewModel: ObservableObject {
    @Published var vaccineModel = [FriendsDetailedVaccineModel]()
    
    func fetchJSON(googleID: String){
        self.decodeJSON(googleID: googleID) { (result) in
            if result == true {
                print("Success fetching Friends JSON")
            }
        }
    }
    
    /// Arkadaş aşıları GET
    func decodeJSON(googleID: String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(baseURL)/user/friends?google_id=\(googleID)") else {return}
        //guard let url = URL(string: "http://127.0.0.1:5000/user/friends?google_id=demo_google_id_1") else {return}
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else {return}
            do {
            
                
               
                let rss = try decoder.decode(FriendsVaccineModel.self, from: data)
                print(rss)
                DispatchQueue.main.async {
                    self.vaccineModel = rss.friends
                    
                    completion(true)
                }
            } catch {
                print("Friends List catch error (\(baseURL)/user/friends?google_id=\(googleID))")
                print("caught: \(error)")
            }
        }.resume()
    }
}
