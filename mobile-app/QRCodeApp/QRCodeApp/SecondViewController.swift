//
//  SecondViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 20.03.2021.
//

import UIKit

class SecondViewController: UIViewController {
    var my_vaccines: [String] = []
    var my_vaccines_friends: [String] = []
    var my_friends_vaccines_list: [[[String : Any]]] = []
    var all_my_vaccines_inform : [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        My_VaccineView_list()
        MyFriends_list()

        // Do any additional setup after loading the view.
    }
    @IBAction func Request_friend(_ sender: Any) {
 
        self.performSegue(withIdentifier: "toFriendsList", sender: nil)
    }
    
    @IBAction func Request(_ sender: Any) {//kisinin ası bilgilerini alıyorum
           
        
        self.performSegue(withIdentifier: "toVaccineViewController", sender: nil)
        
    }
    func  My_VaccineView_list() {
        // 1) Request & Session olusturdum
         // 2) Response & Data datayı aldım
         // 3) Parsing & JSON Serialization
         let url = URL(string: "http://127.0.0.1:5000/user/codes")
         let session = URLSession.shared
         //Closure
 
         let task = session.dataTask(with: url!) { (data, response, error) in
             if error != nil {
                 let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                 let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                 alert.addAction(okButton)
                 self.present(alert, animated: true, completion: nil)
             } else {
                 // 2.
                 if data != nil {
                     do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                         //ASYNC kullanıcı beklerken  arayüz kitlenme olmasın diye
                         //main thread
                         DispatchQueue.main.async {
                            
                            if let info = jsonResponse["my_vaccines"] as? [[String : Any]] {
                                self.all_my_vaccines_inform = info
                                print(info)
                               // if let tl = rates["name"] as? String {
                                //  self.response.text = "TRY: \(tl)"
                               // }
                                for case let result in info {
                                   // print(result)
                                   // print("*****")
                                    if let vaccine = result["name"] as? String{
                                                        
                                        self.my_vaccines.append(vaccine)
                                                    }
                                                }
                            }
                         //   for word in self.my_vaccines {
                                
                            //    print(word)
                            //}
                            
                            
                         }
                        
                     } catch {
                        print("error")
                     }
                 }
             }
         }
    
         task.resume()
    
        
    }
    
    func  MyFriends_list() {
        
        // 1) Request & Session olusturdum
         // 2) Response & Data datayı aldım
         // 3) Parsing & JSON Serialization
         let url = URL(string: "http://127.0.0.1:5000/user/friends")
         let session = URLSession.shared
         //Closure
 
         let task = session.dataTask(with: url!) { (data, response, error) in
             if error != nil {
                 let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                 let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                 alert.addAction(okButton)
                 self.present(alert, animated: true, completion: nil)
             } else {
                 // 2.
                 if data != nil {
                     do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                         //ASYNC kullanıcı beklerken  arayüz kitlenme olmasın diye
                         //main thread
                         DispatchQueue.main.async {
                            
                            if let info = jsonResponse["friends"] as? [[String : Any]] {
                                print(info)
                               // if let tl = rates["name"] as? String {
                                //  self.response.text = "TRY: \(tl)"
                               // }
                                for case let result in info {
                                   // print(result)
                                   // print("*****")
                                    if let vaccine = result["name"] as? String{
                                                        
                                        self.my_vaccines_friends.append(vaccine)
                                                    }
                                    if let friends_vaccine = result["vaccines"] as? [[String : Any]] {
                                                        
                                        self.my_friends_vaccines_list.append(friends_vaccine)
                                                    }
                                    
                                    
                                                }
                            }
                            //for word in self.my_vaccines_friends {
                                
                              //  print(word)
                               
                            //}
                            print("EEE****")
                            for word in self.my_friends_vaccines_list {
                                
                                print(word)
                               
                                print("EE****")
                            }
                            
                         }
                        
                     } catch {
                        print("error")
                     }
                 }
             }
         }
    
         task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //seque olmadan önce yapılacak sey.
        if segue.identifier == "toVaccineViewController" {
            let destinationVC = segue.destination as! VaccineViewController
            destinationVC.my_vaccines_list = my_vaccines
            destinationVC.all_my_vaccines_inform = all_my_vaccines_inform
        }
        if segue.identifier == "toFriendsList" {
            let destinationVC = segue.destination as! FriendsListViewController
            destinationVC.my_friends_list = my_vaccines_friends
            destinationVC.my_friends_vaccines_list = my_friends_vaccines_list
        }
        
    }
}
