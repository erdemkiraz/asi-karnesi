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
    var all_my_vaccines_inform : [[String : Any]] = []
    var choosen_vaccines_index : Int = 0
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosen_vaccines_index = indexPath.row
        performSegue(withIdentifier: "toInfoMyVaccaine", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //seque olmadan önce yapılacak sey.
        if segue.identifier == "toInfoMyVaccaine" {
           let destinationVC = segue.destination as! InfoMyVaccasineViewController
            destinationVC.choosen_my_vaccines_inform = all_my_vaccines_inform[choosen_vaccines_index]
        }
    }
    
    
}
