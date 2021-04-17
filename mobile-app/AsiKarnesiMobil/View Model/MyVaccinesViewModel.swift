//
//  AsilarimViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 5.04.2021.
//

import Foundation
import Combine

class MyVaccinesViewModel: ObservableObject {
    
    @Published var vaccineModel = [DetailedVaccineModel]()
    
    @Published var privacySet = 10
    
    @Published var selectedVaccineID : Int
    
    init(){
        selectedVaccineID = 100
    }
    
    func fetchJSON(googleID: String){
        self.decodeJSON(googleID: googleID) { (result) in
            if result == true {
                print("Success fetching My Vaccines JSON")
            }
        }
    }
    
    /// Aşı Gizliliği POST
    func setPrivacyFunc(vaccination_id: Int, new_privacy: Int, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "vaccination_id": vaccination_id,
            "new_privacy": new_privacy
        ]
        
        
        guard let url = URL(string: "\(baseURL)/set-privacy") else {return}
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                //print(responseJSON)
                //let response = responseJSON
                //let url = response["link"]
                //self.url = url as! String
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Aşı Gizliliği GET
    func getSelectedVaccinePrivacyStatus(completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(baseURL)/get-privacy?vaccination_id=\(selectedVaccineID)") else {return}
        
        //guard let url = URL(string: "http://127.0.0.1:5000/get-privacy?vaccination_id=2") else {return}
        
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(DetailedVaccinePrivacyModel.self, from: data)
                DispatchQueue.main.async {
                    self.privacySet = rss.privacy_setting
                    completion(true)
                }
            } catch {
                print("catch error get privacy")
            }
        }.resume()
    }
    
    /// Tüm aşılar GET
    func decodeJSON(googleID: String, completion: @escaping (Bool) -> Void){
        
        // 1 - Decoding edilecek JSON URL:
        guard let url = URL(string: "\(baseURL)/user/codes?google_id=\(googleID)") else {return}
        
        // 2 - JSONDecoder:
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(VaccineModel.self, from: data)
                DispatchQueue.main.async {
                    self.vaccineModel = rss.my_vaccines
                    completion(true)
                }
                
            } catch {
                print("Vaccines catch error (\(baseURL)/user/codes?google_id=\(googleID))")
            }
        }.resume()
    }
}

