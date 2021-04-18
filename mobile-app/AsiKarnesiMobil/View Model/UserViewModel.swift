//
//  UserViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 15.04.2021.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var userData : UserModel? = nil
    
    func fetchJSON(googleID: String){
        self.decodeJSON(googleID: googleID) { (result) in
            if result == true {
                print("Success fetching User JSON")
            }
        }
    }
    
    func decodeJSON(googleID: String, completion: @escaping (Bool) -> Void){
        
        guard let url = URL(string: "\(baseURL)/user-info?google_id=\(googleID)") else {return}
        
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(UserModel.self, from: data)
                DispatchQueue.main.async {
                    self.userData = rss
                    completion(true)
                }
            } catch {
                print("Current User catch error (\(baseURL)/user-info?google_id=\(googleID))")
            }
        }.resume()
    }
    
    func updateProfile(google_id: String, name: String, age: Int, countryName: String, completion: @escaping (Bool) -> Void){
        
        let params: [String: Any] = [
            "google_id": google_id,
            "name": name,
            "age": age,
            "country_name": countryName,
            "is_update": true
        ]
        
        guard let url = URL(string: "\(baseURL)/update-user-info") else {return}
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
    
}
