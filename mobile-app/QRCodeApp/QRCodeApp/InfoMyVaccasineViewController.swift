//
//  InfoMyVaccasineViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 27.03.2021.
//

import UIKit

class InfoMyVaccasineViewController: UIViewController  ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var choosen_my_vaccines_inform : [String : Any] = [:]
    var my_vaccines_inform : [String] = []
    var asi_id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
     /*   for word in self.choosen_my_vaccines_inform {
            print (word)
        
            print ("YENİ")
            
        }*/
        print ("YENİ")
        asi_id =  choosen_my_vaccines_inform["id"] as! Int
        print (asi_id) //bunu kullanıcaz
        var asi_name : String = choosen_my_vaccines_inform["name"] as! String
        var name = "Aşı İsmi: \(asi_name)"
        var asi_merkezi : String = choosen_my_vaccines_inform["vaccine_point"] as! String
        var vaccine_point = "Aşı Merkezi: \(asi_merkezi)"
        var asi_tarihi : String = choosen_my_vaccines_inform["date"] as! String
        var vaccine_date = "Aşı Tarihi: \(asi_tarihi)"
        var asi_dozu : String = choosen_my_vaccines_inform["dose"] as! String
        var vaccine_dose = "Aşı Dozu: \(asi_dozu)"
        var asi_skt : String = choosen_my_vaccines_inform["expires_in"] as! String
        var vaccine_expires_in = "Aşı Son Kullanım Tarihi : \(asi_skt)"
        self.my_vaccines_inform.append(name as! String)
        self.my_vaccines_inform.append(vaccine_point as! String)
        self.my_vaccines_inform.append(vaccine_date as! String)
        self.my_vaccines_inform.append(vaccine_dose as! String)
        self.my_vaccines_inform.append(vaccine_expires_in as! String)
        //my_vaccines_inform [2] = choosen_my_vaccines_inform["name"] as! String
        //my_vaccines_inform [3] = choosen_my_vaccines_inform["name"] as! String
        tableView.delegate = self
        tableView.dataSource = self
      // tableView.separatorEffect = .none
        
        navigationItem.title = "Aşı Bilgisi"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func vaccine_permission(_ sender: Any) {
        performSegue(withIdentifier: "toPermissionMyVaccaine", sender: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
  
        cell.textLabel?.text = self.my_vaccines_inform[indexPath.row] as? String
     
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //seque olmadan önce yapılacak sey.
        if segue.identifier == "toPermissionMyVaccaine" {
           let destinationVC = segue.destination as! VaccinePermissionViewController
            destinationVC.asi_id = asi_id
        }
    }
    

    

}
