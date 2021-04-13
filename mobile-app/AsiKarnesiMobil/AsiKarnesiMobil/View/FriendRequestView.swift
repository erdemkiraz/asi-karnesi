//
//  FriendRequestView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 9.04.2021.
//

import SwiftUI

struct FriendRequestView: View {
    
    /// Gerekli ViewMode'leri bağlama
    @ObservedObject var viewModel : FriendRequestViewModel
    @ObservedObject var friendModel : FriendsViewModel
    
    /// Görünümü kapatma değeri
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Arkadaşlık İstekleri")
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
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        ForEach(self.viewModel.friendModel, id: \.self){ data in
                            HStack{
                                Text(data.requester_name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.primary)
                                Spacer()
                                
                                /// Kabul etme butonu
                                Button {
                                    self.viewModel.acceptRequest(request_id: data.request_id) { (result) in
                                        if result {
                                            self.viewModel.fetchJSON()
                                            self.friendModel.fetchJSON()
                                        }
                                    }
                                } label: {
                                    Text("Kabul Et")
                                        .font(.system(size: 11, weight: .medium, design: .default))
                                        .foregroundColor(Color.black)
                                        .padding(.vertical,5)
                                        .padding(.horizontal, 10)
                                        .background(Color.green.cornerRadius(5))
                                }
                                
                                /// Reddetme etme butonu
                                Button {
                                    self.viewModel.rejectRequest(request_id: data.request_id) { (result) in
                                        self.viewModel.fetchJSON()
                                        self.friendModel.fetchJSON()
                                    }
                                } label: {
                                    Text("Reddet")
                                        .font(.system(size: 11, weight: .medium, design: .default))
                                        .foregroundColor(Color.black)
                                        .padding(.vertical,5)
                                        .padding(.horizontal, 10)
                                        .background(Color.red.cornerRadius(5))
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
    }
}

