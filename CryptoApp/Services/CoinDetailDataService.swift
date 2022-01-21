//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 19/01/22.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil //publishers can have subscribers
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
    func getCoinsDetails() {
        //using combine
        guard let url = URL(string:
                                //in api bitcoin == coin.id
    "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        )
        else {return}
        
        coinDetailSubscription = NetworkingManager.download(url: url) //its in bg thread now as we comment the .receive there
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder()) //we want to decode on bg thread for optimisation
            .receive(on: DispatchQueue.main) //receive on main thread after decoding
        //.sink always on main thread
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
