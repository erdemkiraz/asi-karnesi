//
//  FriendRequestViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 9.04.2021.
//

import Foundation

class FriendRequestViewModel: ObservableObject {
    
    @Published var friendModel = [DetailedFriendRequestModel]()
    @Published var name = ""
    
    func fetchJSON(googleID: String){
        
        self.decodeJSON(googleID: googleID) { (result) in
            if result == true {
                print("Success fetching Friend Request JSON")
            }
        }
    }
    
    /// Arkadaşlık isteği gönderme POST
    func sendRequest(googleID: String, email: String, completion: @escaping (Bool) -> Void){
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
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Arkadaşlık isteği reddetme POST
    func rejectRequest(request_id: Int, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "request_id": request_id
        ]
        guard let url = URL(string: "\(baseURL)/reject-friend-request") else {return}
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
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Arkadaşlık isteği kabul etme POST
    func acceptRequest(request_id: Int, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "request_id": request_id
        ]
        guard let url = URL(string: "\(baseURL)/accept-friend-request") else {return}
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
                print(responseJSON)
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Arkadaşlık isteklerini alma GET
    func decodeJSON(googleID: String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(baseURL)/friend-requests?google_id=\(googleID)") else {return}
        
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            guard let data = data else {return}
            do {
                let rss = try decoder.decode(FriendRequestModel.self, from: data)
                DispatchQueue.main.async {
                    self.friendModel = rss.friend_requests
                    completion(true)
                }
            } catch {
                print("friend request catch error!")
                completion(false)
            }
        }.resume()
    }
}
