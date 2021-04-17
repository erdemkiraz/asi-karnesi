//
//  AppDelegate.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 5.04.2021.
//

import UIKit
import Firebase
import GoogleSignIn

public var baseURL = "https://asi-karnesi.herokuapp.com"

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // GoogleService-Info.plist'ten otomatik olarak clientID'yi alıyorum. Sorun olması halinde manüel tanımladığım clientID'yi yorum satırı olarak bıraktım.
        //GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.clientID = "141610256272-g14inva32j9ec396msqhdbh1jgrvkede.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance()?.scopes.append("https://www.googleapis.com/auth/contacts.readonly")
        
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
        
        // Giriş yapmış kullanıcının tüm verilerini alabiliyoruz. Fakat istediğimiz veriyi istediğimiz yerde kullanabilmek için farklı yöntemler kullanacağız. Aşağıda anlattım.
        
        //let userId = user.userID
        //let idToken = user.authentication.idToken // Safe to send to the server
        //let fullName = user.profile.name
        //let givenName = user.profile.givenName
        //let familyName = user.profile.familyName
        //let email = user.profile.email
        //
        //print(user.authentication.idToken)
        // ...
        
        // Firebase ve Google Cloud yeri:
        
        // Google Cloud:
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // Firebase:
        Auth.auth().signIn(with: credential) { (result, error) in
            // Hata yoksa, kullanıcının hesabı yoksa yeni hesap yartılacak varsa giriş yapacak. Google Cloud ve Firebase konsolundan görebilirsiniz.
            if error == nil {
                let userIdToken: String = user.authentication.idToken
                let accessToken: String = user.authentication.accessToken
                let userID: String = user.userID
                let email: String = result?.user.email ?? ""
                let name: String = result?.user.displayName ?? ""
                
                // Kullanıcının ID Token'ini UserDefaults sayesinde uygulamanın kalıcı hafızasına kaydediyoruz. Böylece kullanıcı uygulamayı kapatsa bile tekrar tekrar giriş yapmasına ihtiyaç kalmayacak.
                let defaults = UserDefaults.standard
                defaults.set(userIdToken, forKey: "idToken")
                defaults.set(userID, forKey: "userID")
                defaults.set(email, forKey: "email")
                defaults.set(name, forKey: "name")
                defaults.set(accessToken, forKey: "accessToken")
                
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

