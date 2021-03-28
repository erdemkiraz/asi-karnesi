//
//  FriendsListViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 26.03.2021.
//

import UIKit

class FriendsListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var my_friends_list: [String] = []
    var my_friends_vaccines_list: [[[String : Any]]] = []
    var choosen_friends : [[String : Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        for word in self.my_friends_vaccines_list {
            
        print (word)
            print ("basak")
            
        }
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Arkadaşlarım"
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
    
        cell.textLabel?.text = self.my_friends_list[indexPath.row]
          
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.my_friends_list.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosen_friends = my_friends_vaccines_list[indexPath.row]
        performSegue(withIdentifier: "toFriendsVaccine", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //seque olmadan önce yapılacak sey.
        if segue.identifier == "toFriendsVaccine" {
           let destinationVC = segue.destination as! FriendsVaccinesViewController
            destinationVC.choosen_friends = choosen_friends
        }
    }

}
