//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 16/01/22.
//

/*
 We created a MarketDataModel with custom CodingKeys and then we created MarketDataService and here we are we are geting the data (with getData() func ), we're going to that url, we are downloading it, we're decoding it to GlobalData (struct in MarketDataModel) and then from the GlobalData we're going to get the data (that's inside GlobalData struct) which is actually marketData. We are appending the marketData to this published var inside our MarketDataService, so because this is published we can then subscribe to it from other places in our app.
 So in our HomeViewModel, we created a subscriber (marketDataService) that subscribed to  marketData (markeDataService.$marketData).
Every time marketData got published on MarketDataService,this (markeDataService.$marketData) is going to update with that new data. We're then mapping or transforming that data from marketData into an array of statistics, and the statistics is going to this statistcs(published var in HomeViewModel) and this statistics is connected to our HomeStatsView.
 */

import Foundation
import Combine


class MarketDataService {
    @Published var marketData: MarketDataModel? = nil //publishers can have subscribers
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        //using combine
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}

