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
    
    var coin: CoinName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        coinName.text = coin?.CoinName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
