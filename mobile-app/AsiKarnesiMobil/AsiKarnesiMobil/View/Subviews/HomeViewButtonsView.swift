//
//  HomeViewButtonsView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import SwiftUI

struct HomeViewButtonsView: View {
    var title = ""
    var body: some View {
        ZStack{
            ZStack{
                Color.green
                    .cornerRadius(15)
                    .frame(height: 100, alignment: .center)
                Text("\(self.title)")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
        }
    }
}

struct HomeViewButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewButtonsView()
    }
}
