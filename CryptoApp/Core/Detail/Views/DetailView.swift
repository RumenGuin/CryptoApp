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
    
    @StateObject private var dvm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _dvm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        //print("initialising Detail view for \(coin.name)")
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("HI")
                    .frame(height: 150)
                overViewTitle
                Divider()
                overviewGrid
               additionalTitle
                Divider()
               additionalGrid
            }
            .padding()
        }
        .navigationTitle(dvm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}
extension DetailView {
    private var overViewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(dvm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(dvm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
}
