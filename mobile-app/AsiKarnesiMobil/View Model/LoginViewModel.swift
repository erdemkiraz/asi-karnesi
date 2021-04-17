//
//  LoginViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirime on 16.04.2021.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var url = ""
    
    
    func login(google_id: String, name: String, email: String, accessToken: String, completion: @escaping (Bool) -> Void){
        
        let params: [String: Any] = [
            "google_id": google_id,
            "name": name,
            "email": email,
            "access_token": accessToken
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
                let response = responseJSON
                let url = response["new_user"]
                //self.url = url as! String
                print("Returning: \(url)")
                completion(true)
            }
        }
        task.resume()
    }
}
