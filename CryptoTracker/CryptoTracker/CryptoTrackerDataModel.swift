//
//  CryptoTrackerDataModel.swift
//  CryptoTracker
//
//  Created by JustinCaty on 2/12/19.
//  Copyright © 2019 JustinCaty. All rights reserved.
//

import UIKit

struct CoinList: Decodable {
    var Message: String
    var Data: Dictionary<String, CoinName>
}

struct CoinName: Decodable {
    var CoinName: String
    var Symbol: String
    var ImageUrl: String?
}

struct CoinPrice: Decodable {
    var USD: Double?
}

//struct CryptoTracking: Decodable {
//    var Data: [CryptoData]
//}
//
//struct CryptoData: Decodable {
//    var CoinInfo: CryptoCoinInfo
//    var DISPLAY: CryptoCoinPricingInfoFormation
//
//}
//
//struct CryptoCoinInfo: Decodable {
//    var Name: String
//    var ImageUrl: String
//}
//
//struct CryptoCoinPricingInfoFormation: Decodable {
//    var USD: USDInformation
//}
//
//struct USDInformation: Decodable {
//    var PRICE: String
//}

class CryptoTrackerDataModel {
    let session = URLSession.shared
    
    func getCoinList(completionHandler: @escaping (CoinList) -> ()) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/all/coinlist?api_key=00bd6c061026737fd4009bff205f66eaa9fa588f558ee71f9170ac3a51535f21") else { return }
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(CoinList.self, from: data)
                    completionHandler(results)
                } catch {
                    print("Error \(error)")
                }
            }
            
            }.resume()
    }
    
    func coinPrice(symbol: String, completionHandler: @escaping (CoinPrice) -> ()) {
        guard let url = URL(string:  "https://min-api.cryptocompare.com/data/price?fsym=\(symbol)&tsyms=USD&api_key=00bd6c061026737fd4009bff205f66eaa9fa588f558ee71f9170ac3a51535f21") else { return }
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(CoinPrice.self, from: data)
                    completionHandler(results)
                } catch {
                    print("Error \(error)")
                }
            }
            
        }.resume()
    }
    
    func getImageFromUrl(imageURL: String, completionHandler: @escaping (Data) -> ()) {
        guard let url = URL(string: "https://www.cryptocompare.com\(imageURL)") else { return }
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completionHandler(data)
            }
        }.resume()
    }
    
    func cancelTask(){
    }
}

//        guard let iconURL = URL(string: "https://www.cryptocompare.com\(imageURL)"),
//            let data = try? Data(contentsOf:iconURL) else { fatalError() }
//        return data
