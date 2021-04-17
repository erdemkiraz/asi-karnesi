//
//  GoogleContactsViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 17.04.2021.
//

import Foundation

class GoogleContactsViewModel: ObservableObject {
    @Published var data = [DetailedGoogleContactsModel]()
    
    
    
    func sendSMS(google_id: String, friend_phone: String, friend_name: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "google_id": google_id,
            "friend_phone": friend_phone,
            "name": friend_name
        ]
        guard let url = URL(string: "\(baseURL)/invite-sms") else {return}
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
                print(response["message"])
                print("success")
                completion(true)
            }
        }
        task.resume()
    }
    
    func sendEmail(google_id: String, friend_email: String, friend_name: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "google_id": google_id,
            "friend_email": friend_email,
            "name": friend_name
        ]
        guard let url = URL(string: "\(baseURL)/invite-email") else {return}
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            //print(responseJSON)
            if let responseJSON = responseJSON as? [String:Any] {
                let response = responseJSON
                print(response["message"])
                print("success")
                completion(true)
                
            }
        }
        task.resume()
    }
    
    func sendFriendRequest(googleID: String, email: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "google_id": googleID,
            "friend_email": email.lowercased()
        ]
        guard let url = URL(string: "\(baseURL)/friend-request") else {return}
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
                print("tamam")
                completion(true)
            }
        }
        task.resume()
    }
    
    
    
    
    func fetchJSON(googleID: String){
        self.decodeJSON(googleID: googleID) { (result) in
            if result == true {
                print("Success fetching Google Contacts JSON")
            }
        }
    }
    
    func decodeJSON(googleID: String, completion: @escaping (Bool) -> Void){
        
        guard let url = URL(string: "\(baseURL)/google/my-friends?google_id=\(googleID)") else {return}
        
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(GoogleContactsModel.self, from: data)
                DispatchQueue.main.async {
                    self.data = rss.friends
                    completion(true)
                }
            } catch {
                print("Google Contacts catch error")
            }
        }.resume()
    }
}
