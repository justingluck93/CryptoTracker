//
//  CryptoCoinInformationViewController.swift
//  CryptoTracker
//
//  Created by JustinCaty<3 on 2/15/19.
//  Copyright © 2019 JustinCaty. All rights reserved.
//

import UIKit

class CryptoCoinInformationViewController: UIViewController {

    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    
    var image: UIImage?
    var coin: CoinName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        coinName.text = coin?.FullName
        coinImage.image = image
    }
    
}
