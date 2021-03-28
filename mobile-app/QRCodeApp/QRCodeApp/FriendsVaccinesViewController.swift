//
//  FriendsVaccinesViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 27.03.2021.
//

import UIKit

class FriendsVaccinesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var choosen_friends : [[String : Any]] = []
    var counter : Int = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for word in self.choosen_friends {
            print (word)
        print (word["vaccine"]  as! String)
            print ("elif")
            
        }
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Arkadaşımın Aşıları"
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = self.choosen_friends[indexPath.row]["vaccine"] as! String
        //cell.textLabel?.text="basak"
        print("deneme")
       // print(self.choosen_friends[indexPath.row]["vaccine"])
    
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choosen_friends.count
    }
    
    
    
    

}
