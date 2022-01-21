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
    @State private var showFullDescription: Bool = false
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
            VStack {
                ChartView(coin: dvm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    
                    overViewTitle
                    Divider()
                    
                    descriptionSection
                    
                    overviewGrid
                   additionalTitle
                    
                    Divider()
                   additionalGrid
                    
                    websiteSection
                        
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(dvm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navBarTrailItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
        .preferredColorScheme(.dark)
    }
}
extension DetailView {
    
    private var navBarTrailItems: some View {
            HStack {
                Text(dvm.coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                
                CoinImageView(coin: dvm.coin)
                    .frame(width: 25, height: 25)
                
            }
    }
    
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
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = dvm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            //toggle linelimit
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read More..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

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
    private var websiteSection: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            if let websiteString = dvm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = dvm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
            
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
