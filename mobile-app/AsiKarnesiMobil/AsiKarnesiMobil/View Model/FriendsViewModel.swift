//
//  FriendsViewModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 8.04.2021.
//

import SwiftUI

class FriendsViewModel: ObservableObject {
    @Published var vaccineModel = [FriendsDetailedVaccineModel]()
    
    func fetchJSON(){
        self.decodeJSON { (result) in
            if result == true {
                print("Success fetching Friends JSON")
            }
        }
    }
    
    /// Arkadaş aşıları GET
    func decodeJSON(completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "http://127.0.0.1:5000/user/friends?google_id=123") else {return}
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(FriendsVaccineModel.self, from: data)
                DispatchQueue.main.async {
                    self.vaccineModel = rss.friends
                    completion(true)
                }
            } catch {
                print("catch error")
            }
        }.resume()
    }
}
