//
//  VaccineViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 26.03.2021.
//

import UIKit

class VaccineViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    
  
    @IBOutlet weak var tableView: UITableView!
    var my_vaccines_list: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      //  for word in self.my_vaccines_list {
            
        //    print(word)
        //}
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Aşılarım"
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
    
        cell.textLabel?.text = self.my_vaccines_list[indexPath.row]
          
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.my_vaccines_list.count
    }
}
