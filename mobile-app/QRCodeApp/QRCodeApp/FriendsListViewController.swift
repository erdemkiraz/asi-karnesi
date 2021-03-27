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
    override func viewDidLoad() {
        super.viewDidLoad()
        for word in self.my_friends_vaccines_list {
            
        print (word)
            
        }
        tableView.delegate = self
        tableView.dataSource = self

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
        
        performSegue(withIdentifier: "toVaccineViewController", sender: nil)
    }

}
