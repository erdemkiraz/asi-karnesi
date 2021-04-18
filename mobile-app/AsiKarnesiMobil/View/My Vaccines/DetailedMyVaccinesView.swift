//
//  DetailedMyVaccinesView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI
import UIKit

struct DetailedMyVaccinesView: View {
    
    /// Verileri çekmek için
    var data : DetailedVaccineModel
    
    @ObservedObject var viewModel : MyVaccinesViewModel
    
    /// Gizlilik ayarını göstermek için
    @State var show = false
    
    var body: some View {
        ZStack{
            VStack{
                /// Row görünümü oluşturmak için oluşturduğumuz model. data'ya bağlıyoruz.
                DetailedVaccinesRow(date: data.date, dose: data.dose, name: data.name, vaccination_id: data.vaccination_id, vaccine_id: data.vaccine_id, vaccine_point: data.vaccine_point, valid_until: data.valid_until)
            }
            VStack{
                Spacer()
                Button {
                    self.show = true
                } label: {
                    Text("Aşı İzinlerini Düzenle")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 25)
                        .background(Color.purple.cornerRadius(15))
                        .padding(.bottom, 15)
                }
            }
            .padding(.bottom, 15)
        }
        .navigationBarItems(trailing: Button {
            let tweetText = "Ben"
            let tweetUrl = " \(data.name) aşısı oldum. Aşı Karnesi"
            let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: escapedShareString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
            }
        } label: {
            Image("twitter")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 34, alignment: .center)
        })
        .navigationTitle("Aşı Bilgisi")
        .sheet(isPresented: $show){
            VaccinePermitsView(viewModel: viewModel)
        }
        
        /// Görünüm her gözüktüğünde seçilen aşının vaccination_id sini kaydediyoruz. Bu sayede yeni gizliliği ayarlayabiliriz.
        .onAppear {
            self.viewModel.selectedVaccineID = data.vaccination_id
            self.viewModel.getSelectedVaccinePrivacyStatus { (result) in
                
            }
        }
    }
}




struct VaccinePermitsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel : MyVaccinesViewModel
    
    /// Yeni değer
    @State var permission: Int = 1
    
    var body: some View {
        VStack{
            HStack{
                Text("Aşı İzinleri")
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
            
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Text("Gizli")
                        .font(.system(size: 26, weight: .bold, design: .default))
                    Spacer()
                    Button {
                        self.permission = 0
                    } label: {
                        Image(systemName: self.permission == 0 ? "circle.fill" : "circle")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                }
                Divider()
                HStack{
                    Text("Tüm Adminler")
                        .font(.system(size: 26, weight: .bold, design: .default))
                    Spacer()
                    Button {
                        self.permission = 1
                    } label: {
                        Image(systemName: self.permission == 1 ? "circle.fill" : "circle")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                }
                Divider()
                HStack{
                    Text("Arkadaşlar")
                        .font(.system(size: 26, weight: .bold, design: .default))
                    Spacer()
                    Button {
                        self.permission = 3
                    } label: {
                        Image(systemName: self.permission == 3 ? "circle.fill" : "circle")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                }
                Divider()
                HStack{
                    Text("Herkes")
                        .font(.system(size: 26, weight: .bold, design: .default))
                    Spacer()
                    Button {
                        self.permission = 5
                    } label: {
                        Image(systemName: self.permission == 5 ? "circle.fill" : "circle")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.top, 20)
            
            /// Aşı izinlerini güncelleme butonu
            Button {
                self.viewModel.setPrivacyFunc(vaccination_id: self.viewModel.selectedVaccineID, new_privacy: self.permission) { (result) in
                    if result {
                        self.viewModel.getSelectedVaccinePrivacyStatus { (result) in
                            if result {
                                self.presentationMode.wrappedValue.dismiss()
                                print("Success Update Vaccine Privacy")
                            }
                        }
                    }
                }
            } label: {
                Text("Kaydet")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 25)
                    .background(Color.purple.cornerRadius(15))
                    .padding(.bottom, 15)
            }
            Spacer()
        }
        .onAppear {
            self.permission = self.viewModel.privacySet
        }
    }
}
