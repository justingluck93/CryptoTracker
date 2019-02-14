//
//  ViewController.swift
//  CryptoTracker
//
//  Created by JustinCaty on 2/12/19.
//  Copyright © 2019 JustinCaty. All rights reserved.
//

import UIKit

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var cryptoTrackerData = CryptoTrackerDataModel()
    var results: CoinList?
    var coinList: [CoinName]?
    var sortedCoinList: [CoinName]?
    var filterdCoinList: [CoinName]?
    var isSearching: Bool = false
    
    //@IBOutlet weak var coinListPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        coinListPicker.delegate = nil
//        coinListPicker.dataSource = nil
        loadCryptoData()
    }
    
    func loadCryptoData() {
        cryptoTrackerData.getCoinList() { (coinList) in
            self.results = coinList
            self.coinList = [CoinName](coinList.Data.values)
            DispatchQueue.main.sync {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.searchBar.delegate = self
                self.searchBar.returnKeyType = .done
                self.tableView.reloadData()
            }
        }
    }
    
    //SearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filterdCoinList = coinList?.filter({$0.CoinName.localizedCaseInsensitiveContains(searchBar.text!)})
            tableView.reloadData()
        }
    }
    
    //TableViewDelegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let coins = isSearching ? filterdCoinList?.count : coinList?.count
       // guard let coins = coinList?.count else { fatalError() }
        return coins!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath)
        
        guard var coinList = isSearching ? filterdCoinList : coinList else {fatalError()}
        coinList = coinList.sorted { $0.CoinName < $1.CoinName }
        self.sortedCoinList = coinList
        
        myCell.textLabel?.text = "\(coinList[indexPath.row].CoinName)"
        
//        guard let symbol = self.sortedCoinList?[indexPath.row].Symbol else { fatalError() }
//            cryptoTrackerData.coinPrice(symbol: symbol) { (coinPrice) in
//                DispatchQueue.main.sync {
//                    myCell.imageView?.image = UIImage(data: self.cryptoTrackerData.getImageFromUrl(imageURL: (self.sortedCoinList?[indexPath.row].ImageUrl)!))
//                }
//            }
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
}

