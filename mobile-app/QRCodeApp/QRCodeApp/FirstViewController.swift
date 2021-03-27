//
//  FirstViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 20.03.2021.
//

import UIKit
import Firebase

import GoogleSignIn
class FirstViewController: UIViewController {
    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController=self
        
        
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func MainPageButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toMainPage", sender: nil)
       
    }
    public  func updateScreen() {
        performSegue(withIdentifier: "toMainPage", sender: nil)
       
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
