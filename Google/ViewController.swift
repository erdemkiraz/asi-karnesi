//
//  ViewController.swift
//  Google
//
//  Created by Elif Basak  Yildirim on 2.03.2021.
//

import UIKit
import GoogleSignIn
class ViewController: UIViewController {
    //Googlesign in butonu ekledim oturum açma isteği eklendi yani ve butonun classını GIDSignin yaptım
    @IBOutlet var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController=self
    }


}

