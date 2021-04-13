//
//  LoginView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 6.04.2021.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct LoginView: View {
    
    @State var isPresented = false
    
    /// Auth() sınıfı FirebaseAuth'tan geliyor
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        VStack{
            // Google SignIn butonu:
            Google()
                .frame(width: UIScreen.main.bounds.width / 2, height: 60, alignment: .center)
                .padding(.top, 50)
            Spacer()
                
        }
        /// Bu görünüm her gözüktüğünde çağırılacak fonksiyon:
        .onAppear(perform: {
            /// App Delegate'te giriş yaptıktan sonra değişen NotificationCenter sayesinde signin den sonra kullanıcıyı ana sayfaya alabiliyoruz.
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (notification) in
                self.isPresented = true
            }
            if user?.uid != nil {
                print("Giriş Başarılı")
            } else {
                print("Kullanıcı Yok")
            }
        })
        .fullScreenCover(isPresented: $isPresented, content: HomeView.init)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// Google SignIn butonu:
struct Google: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
}
