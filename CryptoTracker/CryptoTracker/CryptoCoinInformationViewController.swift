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
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    var image: UIImage?
    var coin: CoinName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadData()
    }
    
    func loadData() {
//        imageView.layer.borderWidth = 3
//        imageView.layer.borderColor = UIColor.black.cgColor
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

                    guard let high = self.dailyCoinData?.Data[0].high else { return }
                    self.high.text =  "High: $\(high)"

                    guard let close = self.dailyCoinData?.Data[0].close else { return }
                    self.close.text = "Close: $\(close)"
                    
                    guard let timeStamp = self.convertDate(milliseconds: (self.dailyCoinData?.Data[1].time)!) else {return}
                    self.currentTime.text = "Time: \(timeStamp)"
                }
            })
        }
    }
    
    func convertDate(milliseconds: Int) -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(milliseconds))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "E, MMM d h:mm a"
        
        return dateFormatter.string(from: date)
    }
}
