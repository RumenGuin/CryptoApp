//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 13/01/22.
//

import Foundation
import Combine

/*
our view(HomeView) has reference to view model(HomeViewModel) and this view model is then has a dataService which are initializing a new CoinDataService() and when we initialize this CoinDataService(), in the initializers it is calling getCoins(). This func gonna go to our url, its gonna download the data, its gonna check it is valid data, its gonna decode that data and then its gonna take that data and append to the allCoins array which we have here(in CoinDataService). When things get appended to this array because it is @Published, anything subscribed to this publisher will also get notified and back in our HomeViewModel() we added this subcribers (func addSubscribers) and the first subscriber here is subscribing to the dataService.$allCoins (this array is allCoins @Published var array in CoinDataService).
 When we get data published here(in CoinDataService) its gonna also publish in HomeViewModel because we are subscribing to that data.
 */

class CoinDataService {
    @Published var allCoins: [CoinModel] = [] //publishers can have subscribers
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        //using combine
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default)) //bg thread
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main) // receive on main thread
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            }
        
            
    }
}
