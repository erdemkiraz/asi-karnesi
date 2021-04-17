//
//  GoogleContactsView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 17.04.2021.
//

import SwiftUI

struct GoogleContactsView: View {
    
    @ObservedObject var viewModel : GoogleContactsViewModel
    
    @AppStorage("userID") var userID = ""
    
    @State var status = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if self.status != "" {
                        Text(self.status)
                            .foregroundColor(.green)
                            .font(.system(size: 12, weight: .semibold, design: .default))
                        Spacer()
                    }
                    
                }
                .padding(.leading, 15)
                .padding(.top, 10)
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        /// ViewModel içerisindeki GET ile aldığımız datayı vaccineModel dizisinden çekiyoruz ve data isimli değişkene koyuyoruz.
                        ForEach(self.viewModel.data, id: \.self){ data in
                            HStack{
                                VStack(alignment: .leading, spacing: 3){
                                    if data.name != ""{
                                        Text(data.name)
                                            .foregroundColor(.white)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    }
                                    if data.phone != ""{
                                        Text(data.phone)
                                            .font(.system(size: 15, weight: .regular, design: .default))
                                            .foregroundColor(Color.init(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0))
                                    }
                                    if data.email != "" {
                                        Text(data.email)
                                            .font(.system(size: 15, weight: .regular, design: .default))
                                            .foregroundColor(Color.init(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0))
                                    }
                                }
                                Spacer()
                                if data.is_user {
                                    Button {
                                        self.status = ""
                                        self.viewModel.sendFriendRequest(googleID: self.userID, email: data.email) { (result) in
                                            if result {
                                                self.viewModel.fetchJSON(googleID: self.userID)
                                                self.status = "\(data.name) arkadaşlık isteği gönderildi."
                                            }
                                        }
                                    } label: {
                                        Text("Arkadaş Ekle")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12, weight: .semibold, design: .default))
                                            .padding(.vertical,20)
                                            .padding(.horizontal,20)
                                            .background(Color.purple.cornerRadius(5))
                                    }

                                } else {
                                    HStack(spacing:5){
                                        if data.phone != "" {
                                            Button {
                                                self.status = ""
                                                self.viewModel.sendSMS(google_id: self.userID, friend_phone: data.phone, friend_name: data.name) { (result) in
                                                    if result {
                                                        self.viewModel.fetchJSON(googleID: self.userID)
                                                        self.status = "\(data.name) davet gönderildi."
                                                    }
                                                }
                                            } label: {
                                                VStack{
                                                    Image(systemName:"message.fill")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 11, weight: .medium, design: .default))
                                                    Text("SMS")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 11, weight: .medium, design: .default))
                                                    Text("DAVET")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 9, weight: .medium, design: .default))
                                                }
                                                .padding(.vertical,10)
                                                .padding(.horizontal,20)
                                                .background(Color.purple.cornerRadius(5))
                                            }
                                        }
                                        if data.email != "" {
                                            Button {
                                                self.status = ""
                                                self.viewModel.sendEmail(google_id: self.userID, friend_email: data.email, friend_name: data.name) { (result) in
                                                    if result {
                                                        self.viewModel.fetchJSON(googleID: self.userID)
                                                        self.status = "\(data.name) davet gönderildi."
                                                    }
                                                }
                                            } label: {
                                                VStack{
                                                    Image(systemName:"envelope.fill")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 11, weight: .medium, design: .default))
                                                    Text("EMAIL")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 11, weight: .medium, design: .default))
                                                    Text("DAVET")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 9, weight: .medium, design: .default))
                                                }
                                                .padding(.vertical,10)
                                                .padding(.horizontal,20)
                                                .background(Color.purple.cornerRadius(5))
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                            Divider()
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 25)
                }
            }
        }
        .navigationTitle("Google Contacts")
    }
}

