//
//  FriendRequestViewModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 9.04.2021.
//

import Foundation

class FriendRequestViewModel: ObservableObject {
    
    @Published var friendModel = [DetailedFriendRequestModel]()
    
    func fetchJSON(){
        
        self.decodeJSON { (result) in
            if result == true {
                print("Success fetching Friend Request JSON")
            }
        }
    }
    
    /// Arkadaşlık isteği gönderme POST
    func sendRequest(googleID: String, email: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "google_id": googleID,
            "friend_email": email
        ]
        guard let url = URL(string: "http://127.0.0.1:5000/friend-request") else {return}
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
    
    /// Arkadaşlık isteği reddetme POST
    func rejectRequest(request_id: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "request_id": request_id
        ]
        guard let url = URL(string: "http://127.0.0.1:5000/reject-friend-request") else {return}
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
    
    /// Arkadaşlık isteği kabul etme POST
    func acceptRequest(request_id: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "request_id": request_id
        ]
        guard let url = URL(string: "http://127.0.0.1:5000/accept-friend-request") else {return}
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
                //let response = responseJSON
                //let url = response["link"]
                //self.url = url as! String
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Arkadaşlık isteklerini alma GET
    func decodeJSON(completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "http://127.0.0.1:5000/friend-requests?google_id=12332154") else {return}
        
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
                print("catch error")
            }
        }.resume()
    }
}
