//
//  AddFriendsView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 9.04.2021.
//

import SwiftUI

struct AddFriendsView: View {
    
    @ObservedObject var viewModel : FriendRequestViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    /// Bellekte kayıtlı GoogleID.
    @AppStorage("userID") var userID = ""
    
    /// TextField değeri:
    @State var email = ""
    
    @State var sended = false
    @State var empty = false
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Arkadaş Ekle")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    Spacer()
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                }
                .padding(.horizontal,15)
                .padding(.vertical,10)
                
                TextField("Arkadaş Email:", text: $email)
                    .frame(height: 60)
                    .padding(.top,20)
                    .padding(.horizontal, 25)
                Divider()
                
                if self.sended == true {
                    Text("Arkadaşlık İsteği Gönderildi")
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .padding(.top, 15)
                }
                if self.empty == true {
                    Text("Eposta adresi boş olamaz")
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .padding(.top, 15)
                }
                Button {
                    if self.email != "" {
                        self.viewModel.sendRequest(googleID: self.userID, email: self.email) { (result) in
                            if result {
                                self.sended = true
                            }
                        }
                    } else if self.email == "" {
                        self.empty = true
                    }
                    
                } label: {
                    Text("Gönder")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 25)
                        .background(Color.green.cornerRadius(15))
                        .padding(.bottom, 15)
                        .padding(.top, 20)
                }

                Spacer()
            }
        }
        /// email değişkeni her değiştiğinde uyarı mesajları gitmesi için
        .onChange(of: self.email) { (q) in
            self.sended = false
            self.empty = false
        }
    }
}
