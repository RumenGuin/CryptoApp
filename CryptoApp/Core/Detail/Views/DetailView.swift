//
//  DetailView.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 19/01/22.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var dvm: DetailViewModel
    init(coin: CoinModel) {
        _dvm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("initialising Detail view for \(coin.name)")
    }
    var body: some View {
        Text("Hello")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
