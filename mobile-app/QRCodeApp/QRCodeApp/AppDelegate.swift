//
//  AppDelegate.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 26.02.2021.
//

import GoogleSignIn
import Firebase
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate  {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        // Override point for customization after application launch.
        //firebase configuresinden sonra GoogleService-info da clientID yi aldım.
        
        GIDSignIn.sharedInstance()?.clientID="896551858622-8jlvbqi0udknaqesp0tt9muicfm83pnd.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        return true
    }
    //emailname ve authentication idTokeni print ettiriyorum
   func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let userId = user.userID
        let idToken = user.authentication.idToken // Safe to send to the server
          let fullName = user.profile.name
          let givenName = user.profile.givenName
          let familyName = user.profile.familyName
          let email = user.profile.email
        print("User email: \(user.profile.email ?? "No Email")")
        print("User tokenId: \(user.authentication.idToken ?? "No Email")")
    }
   
    
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        return GIDSignIn.sharedInstance().handle(url)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

