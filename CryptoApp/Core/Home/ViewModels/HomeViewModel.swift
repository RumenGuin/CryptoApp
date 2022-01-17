//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 03/01/22.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        //anytime we change the allCoins(in CoinDataService) array we're gonna also get that returned here
        //and we take it from here and append it to our allCoins(in HomeViewModel) array
        
//        dataService.$allCoins //publisher from coindataservice
//            .sink {[weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)

        
        
        //updates allCoins(published var up here)
        $searchText
            .combineLatest(coinDataService.$allCoins)
            // this debounce will wait 0.5 sec before running rest of the code down here, and its waiting to see if we get another published value
            //if i type quickly here you're gonna see that its not going to filter until it stops receiving values for 0.5 sec
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //updates market data
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        guard !text.isEmpty else {
            //if empty
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)

        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    
        
    }
}
