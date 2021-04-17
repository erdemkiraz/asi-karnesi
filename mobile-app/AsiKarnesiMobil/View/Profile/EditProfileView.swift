//
//  EditProfileView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 15.04.2021.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var customBlue = Color.init(red: 144.0/255.0, green: 163.0/255.0, blue: 184.0/255.0)
    
    @ObservedObject var viewModel : UserViewModel
    
    @AppStorage("userID") var userID = ""
    
    @State var name = ""
    @State var age = ""
    @State var selectedCountry = ""
    
    @State var show = false
    
    var countries = ["Turkey", "USA", "UK", "Germany", "Finland","Denmark","Switzerland","Iceland", "Not Given"]
    
    var body: some View {
        ZStack(alignment: .top){
            Color.black
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                .opacity(0.000001)
                .onTapGesture {
                    self.hideKeyboard()
                }
            VStack{
                HStack{
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                        self.hideKeyboard()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                    Spacer()
                    Text("Profili Düzenle")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    Spacer()
                    Button {
                        
                        self.viewModel.updateProfile(google_id: self.userID, name: self.name, age: Int(self.age) ?? 0, countryName: self.selectedCountry) { (result) in
                            if result {
                                self.viewModel.fetchJSON(googleID: self.userID)
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }
                        }
                    } label: {
                        Text("Save")
                    }
                }
                .padding(.horizontal,15)
                .padding(.vertical,10)
                if let data = self.viewModel.userData?.info {
                    VStack(alignment: .leading, spacing:  15){
                        VStack(alignment: .leading, spacing:0){
                            Text("İsim")
                                .foregroundColor(customBlue)
                                .font(.system(size: 14, weight: .regular, design: .default))
                            TextField(data.name, text: $name)
                                .font(.system(size: 26, weight: .bold, design: .default))
                        }
                        Divider()
                        VStack(alignment: .leading, spacing:0){
                            Text("Yaş")
                                .foregroundColor(customBlue)
                                .font(.system(size: 14, weight: .regular, design: .default))
                            
                            
                            
                            if data.age == nil {
                                TextField("Belirtilmemiş", text: $age)
                                    .font(.system(size: 26, weight: .bold, design: .default))
                                    .keyboardType(.decimalPad)
                            } else {
                                TextField(String(data.age!), text: $age)
                                    .font(.system(size: 26, weight: .bold, design: .default))
                                    .keyboardType(.decimalPad)
                            }
                            
                        }
                        Divider()
                        VStack(alignment: .leading, spacing:0){
                            Text("Ülke")
                                .foregroundColor(customBlue)
                                .font(.system(size: 14, weight: .regular, design: .default))
                            Button {
                                withAnimation(.default){
                                    self.show.toggle()
                                }
                            } label: {
                                HStack{
                                    if self.selectedCountry == "" {
                                        Text("Belirtilmemiş")
                                            .foregroundColor(.white)
                                            .font(.system(size: 26, weight: .bold, design: .default))
                                    } else {
                                        Text(self.selectedCountry)
                                            .foregroundColor(.white)
                                            .font(.system(size: 26, weight: .bold, design: .default))
                                    }
                                    
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                        .rotationEffect(.degrees(self.show == true ? 180 : 0))
                                }
                            }
                            
                            if self.show == true{
                                Picker(data.country_name, selection: $selectedCountry) {
                                    ForEach(countries, id: \.self) {
                                        Text($0)
                                            .foregroundColor(.white)
                                            .font(.system(size: 26, weight: .bold, design: .default))
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            if let data = viewModel.userData?.info{
                if data.country_name == "" {
                    self.selectedCountry = "Not Given"
                } else {
                    self.selectedCountry = data.country_name
                }
            }
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
    }
}
#endif
