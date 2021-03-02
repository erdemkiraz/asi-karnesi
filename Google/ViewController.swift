//
//  ViewController.swift
//  Google
//
//  Created by Elif Basak  Yildirim on 2.03.2021.
//

import UIKit
import GoogleSignIn
class ViewController: UIViewController {
    @IBOutlet var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController=self
    }


}

