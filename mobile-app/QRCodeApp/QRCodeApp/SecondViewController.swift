//
//  SecondViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 20.03.2021.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var response: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Request(_ sender: Any) {
            // 1) Request & Session olusturdum
             // 2) Response & Data datayı aldım
             // 3) Parsing & JSON Serialization
             
             
             // 1.
             let url = URL(string: "http://data.fixer.io/api/latest?access_key=f1a698bb5d536ee794e3c21f89f1a337")
             
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
                                 if let rates = jsonResponse["rates"] as? [String : Any] {
                                     //print(rates)
                                     
                                     if let tl = rates["TRY"] as? Double {
                                        self.response.text = "TRY: \(tl)"
                                     }
                                     
                                    
                                     
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
