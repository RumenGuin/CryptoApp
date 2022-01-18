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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsreversed, price, priceReversed
        
    }
    
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
            .combineLatest(coinDataService.$allCoins, $sortOption)
            // this debounce will wait 0.5 sec before running rest of the code down here, and its waiting to see if we get another published value
            //if i type quickly here you're gonna see that its not going to filter until it stops receiving values for 0.5 sec
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        //updates the portfolio coins
        // (subscribe to filtered Coins(published var allCoins up here) rather than coinDataservice.$allCoins)
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else {return} //we have reference to self so its not optional anymore
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        
       
        //updates market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        

        
    }
    
    //updatePortfolio func determine wheather we are adding, updating or deleting those coins from our portfolio, so all we need to do call this func from the view
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
        
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
    //inout -> we are going to take in the array of [CoinModel], and then we want to return out the same array of [CoinModel]
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
            //use sort its more efficient(not sorted)
        case .rank, .holdings:
             coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsreversed:
             coins.sort(by: {$0.rank > $1.rank})
        case .price:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        //will only sort by holdings or reversedHoldings if Needed
        switch sortOption {
       
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsreversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
      
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)

        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue =
            portfolioCoins
                .map({$0.currentHoldingsValue})
                .reduce(0, +)
        
        let previousValue =
        portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue // $1000 (let just 1 coin)
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100  //(see CoinModel) 1.39234 / 100 = 0.0139
            let previousValue = currentValue / (1 + percentChange) // 1000 / (1 + 0.0139) = 1000 / 1.0139 = 986.267799
            return previousValue //986.267799
        }
        .reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        // ((1000 - 986.267799) / 986.267799) * 100 = 0.0139234 * 100 = 1.39234
        //we are getting percentChange = percentageChange because we have taken only 1 coin in portfolioValue.
        
        let portfolio =
            StatisticModel(
                       title: "Portfolio Value",
                       value: portfolioValue.asCurrencyWith2Decimals(),
                       percentageChange: percentageChange)
        
       
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    
        
    }
}
