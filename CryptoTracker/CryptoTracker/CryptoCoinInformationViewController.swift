//
//  CryptoCoinInformationViewController.swift
//  CryptoTracker
//
//  Created by JustinCaty<3 on 2/15/19.
//  Copyright © 2019 JustinCaty. All rights reserved.
//

import UIKit

class CryptoCoinInformationViewController: UIViewController {
    var cryptoTrackerData = CryptoTrackerDataModel()
    var dailyCoinData: HistoricalDaily?
    
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var imageView: UIView!
    
    var image: UIImage?
    var coin: CoinName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadData()
    }
    
    func loadData() {
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
        coinName.text = coin?.FullName
        coinImage.image = image
        
        DispatchQueue.main.async {
            self.cryptoTrackerData.getDailyDataForCoin(symbol: (self.coin?.Symbol)!, completionHandler: { (Data) in
                self.dailyCoinData = Data
                DispatchQueue.main.sync {
                    guard let low = self.dailyCoinData?.Data[0].low else {
                        self.low.text = "N/A"
                        return
                    }
                    self.low.text = "Low: $\(low)"
                }
            })
        }
    }
}
