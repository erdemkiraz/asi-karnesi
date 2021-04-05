//
//  ArkadaslarimView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırımon 5.04.2021.
//

import SwiftUI

struct ArkadaslarimView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    
    var body: some View {
        ZStack{
            
        }
        .navigationBarTitle("Arkadaşlar")
    }
}

struct ArkadaslarimView_Previews: PreviewProvider {
    static var previews: some View {
        ArkadaslarimView(homeViewModel : HomeViewModel())
    }
}
