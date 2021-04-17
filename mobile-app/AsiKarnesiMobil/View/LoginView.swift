//
//  LoginView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 6.04.2021.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct LoginView: View {
    
    @State var isPresented = false
    
    @StateObject var viewModel = LoginViewModel()
    
    @AppStorage("userID") var userID = ""
    @AppStorage("email") var email = ""
    @AppStorage("name") var name = ""
    @AppStorage("accessToken") var accessToken = ""
    
    /// Auth() sınıfı FirebaseAuth'tan geliyor
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 5.0/255.0, green: 0/255.0, blue: 86.0/255.0), Color.init(red: 255.0/255.0, green: 109.0/255.0, blue: 77.0/255.0)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()
            VStack{
                // Google SignIn butonu:
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                Text("Aşı Karnesi")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .semibold, design: .rounded))
                Spacer()
            }
            .padding(.top, 50)
            Google()
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 60, alignment: .center)
        }
        /// Bu görünüm her gözüktüğünde çağırılacak fonksiyon:
        .onAppear(perform: {
            self.isPresented = false
            /// App Delegate'te giriş yaptıktan sonra değişen NotificationCenter sayesinde signin den sonra kullanıcıyı ana sayfaya alabiliyoruz.
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (notification) in
                self.isPresented = true
                self.viewModel.login(google_id: self.userID, name: self.name, email: self.email, accessToken: self.accessToken) { (result) in
                    print("Success Login With Google SignIN")
                }
            }
            if user?.uid != nil {
                print("Giriş Başarılı")
            } else {
                print("Kullanıcı Yok")
            }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
        if(GIDSignIn.sharedInstance()?.presentingViewController==nil){
                GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
              }
              //GIDSignIn.sharedInstance()?.signIn()
        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
    
}
