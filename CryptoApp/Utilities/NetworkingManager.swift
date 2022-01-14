//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 14/01/22.
//
//#7
import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
                
            }
        }
    }
    
    
    static func download(url: URL) ->  AnyPublisher<Data, Error>  {
        //hold option on temp to get the return type of func (put let temp inplace of return to find out)
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default)) //bg thread
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            
            .receive(on: DispatchQueue.main) // receive on main thread
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
              }
        return output.data

    }
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
