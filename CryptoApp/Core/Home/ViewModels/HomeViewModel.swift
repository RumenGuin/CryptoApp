//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 03/01/22.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        //anytime we change the allCoins(in CoinDataService) array we're gonna also get that returned here
        //and we take it from here and append it to our allCoins(in HomeViewModel) array
        dataService.$allCoins //publisher from coindataservice
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
