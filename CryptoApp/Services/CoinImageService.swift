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
 we're going to pass in a coin in CoinImageViewModel and then we're going to initialize a new CoinImageService. When we initialize a new CoinImageService(in CoinImageViewModel), its going to initialize in CoinImageService and then its going to call func downloadCoinImage() and its going to go that url, download the data, convert the data into a UIImage. If its successful its then going to take that returnedImage and append to published image var here(in CoinImageService). And now all we need to do is get this published value here (in CoinImageservice) into our CoinImageViewModel. we are going to subscribe to this published var image (in CoinImageService).
 When we download the image(published var image in CoinImageService) we should subscribe to that (dataService.$image) (in func addSubscribers() in CoinImageViewModel) and it will take our image and put it in (published var image in CoinImageViewModel) and this published var image from CoinImageViewModel is being displayed on the view.
 
 When we call getCoinImage() from init() its going to first check the filemanager. If it can get it we're going to get the image straight from the file manager, if not we're going to then go ahead and download it (downloadCoinImage()) and after we downlaod we're going to save it to the file manager so that if we ever try to get this coin image again it should already be saved and then hopefully this will succeed and we can retrieve it from the file manager.
 */

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManger = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManger.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
           // print("Retrieved image from file Manager")
        } else{
            downloadCoinImage()
           // print("Downloading Image Now")
        }
            
    }
    
    private func downloadCoinImage() {
       
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManger.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
