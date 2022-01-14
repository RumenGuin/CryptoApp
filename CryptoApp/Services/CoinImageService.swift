//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 14/01/22.
//

import Foundation
import SwiftUI
import Combine

/*
 we're going to pass in a coin in CoinImageViewModel and then we're going to initialize a new CoinImageService. When we initialize a new CoinImageService(in CoinImageViewModel), its going to initialize in CoinImageService and then its going to call func getCoinImage() and its going to go that url, download the data, convert the data into a UIImage. If its successful its then going to take that returnedImage and append to published image var here(in CoinImageService). And now all we need to do is get this published value here (in CoinImageservice) into our CoinImageViewModel. we are going to subscribe to this published var image (in CoinImageService).
 When we download the image(published var image in CoinImageService) we should subscribe to that (dataService.$image) (in func addSubscribers() in CoinImageViewModel) and it will take our image and put it in (published var image in CoinImageViewModel) and this published var image from CoinImageViewModel is being displayed on the view.
 */

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
