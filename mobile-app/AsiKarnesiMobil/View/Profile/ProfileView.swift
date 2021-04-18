//
//  ProfileView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 15.04.2021.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel : UserViewModel
    
    var customBlue = Color.init(red: 144.0/255.0, green: 163.0/255.0, blue: 184.0/255.0)
    
    @State var show = false
    
    var body: some View {
        ZStack {
            if let data = self.viewModel.userData?.info {
                VStack(alignment: .leading, spacing:  15){
                    VStack(alignment: .leading, spacing:0){
                        Text("İsim")
                            .foregroundColor(customBlue)
                            .font(.system(size: 14, weight: .regular, design: .default))
                        Text(data.name)
                            .font(.system(size: 26, weight: .bold, design: .default))
                    }
                    Divider()
                    VStack(alignment: .leading, spacing:0){
                        Text("Yaş")
                            .foregroundColor(customBlue)
                            .font(.system(size: 14, weight: .regular, design: .default))
                        if data.age == nil {
                            Text("Belirtilmemiş")
                                .font(.system(size: 26, weight: .bold, design: .default))
                        } else {
                            Text(String(data.age!))
                                .font(.system(size: 26, weight: .bold, design: .default))
                        }
                        
                    }
                    Divider()
                    VStack(alignment: .leading, spacing:0){
                        Text("Ülke")
                            .foregroundColor(customBlue)
                            .font(.system(size: 14, weight: .regular, design: .default))
                        if data.country_name == ""  {
                            Text("Belirtilmemiş")
                                .font(.system(size: 26, weight: .bold, design: .default))
                        } else {
                            Text(String(data.country_name))
                                .font(.system(size: 26, weight: .bold, design: .default))
                        }
                        
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("All set!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("Bildirimlere izin ver")
                                .foregroundColor(.black)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 30)
                                .background(Color.gray.cornerRadius(5))
                        }

                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.top, 20)
            }
        }
        .navigationBarTitle("Profil")
        .navigationBarItems(trailing: Button(action: {
            self.show = true
        }, label: {
            Text("Düzenle")
        }))
        .sheet(isPresented: $show){
            EditProfileView(viewModel: viewModel)
        }
    }
}
