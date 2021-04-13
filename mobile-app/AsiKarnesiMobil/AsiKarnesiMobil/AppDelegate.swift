//
//  AppDelegate.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 5.04.2021.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // GoogleService-Info.plist'ten otomatik olarak clientID'yi alıyorum. Sorun olması halinde manüel tanımladığım clientID'yi yorum satırı olarak bıraktım.
        //GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.clientID = "141610256272-sln6638qe8k9o0cn98uh41rmmbm6c0qr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // Google SignIn fonksiyonu:
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
     
        
        // Firebase ve Google Cloud yeri:
        
        // Google Cloud:
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // Firebase:
        Auth.auth().signIn(with: credential) { (result, error) in
            // Hata yoksa, kullanıcının hesabı yoksa yeni hesap yartılacak varsa giriş yapacak. Google Cloud ve Firebase konsolundan görebilirsiniz.
            if error == nil {
                let userIdToken: String = user.authentication.idToken
                let userID: String = user.userID
                
                // Kullanıcının ID Token'ini UserDefaults sayesinde uygulamanın kalıcı hafızasına kaydediyoruz. Böylece kullanıcı uygulamayı kapatsa bile tekrar tekrar giriş yapmasına ihtiyaç kalmayacak.
                let defaults = UserDefaults.standard
                defaults.set(userIdToken, forKey: "idToken")
                defaults.set(userID, forKey: "userID")
                
                // Ardından kullanıcının giriş yaptığı bilgisini görünümlere aktarabilmek için NotificationCenter kullanıyorum.
                NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
                
                // Kullanıcı verilerini print ettiriyorum.
                //print("ID Token" + (user.authentication.idToken)!)
                //print("user:" + (result?.user.email)!)
                
            } else { // -> Hata varsa:
                print((error?.localizedDescription)!)
                return
            }
        }
    }
    
    // Google SignIn Hata fonksiyonu:
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

