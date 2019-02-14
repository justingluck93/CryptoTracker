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
    var imageDict = [String : UIImage?]()
    
    //@IBOutlet weak var coinListPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCryptoData()
        tableView.prefetchDataSource = self

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
        if let myImage = imageDict[coinList[indexPath.row].CoinName] {
            myCell.imageView?.image = myImage
        }
       
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coinInformation = sortedCoinList?[indexPath.row] else {fatalError()}
        print(coinInformation.Symbol)
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard var coinList = isSearching ? filterdCoinList : sortedCoinList else {fatalError()}
        indexPaths.forEach {
            let coinName = coinList[$0.row].CoinName
            self.cryptoTrackerData.getImageFromUrl(imageURL: coinList[$0.row].ImageUrl!, completionHandler: { (Data) in
                self.imageDict[coinName] = UIImage(data: Data)
            })
            //imageDict[coinList[$0.row].CoinName] = UIImage(data: self.cryptoTrackerData.getImageFromUrl(imageURL: coinList[$0.row].ImageUrl!))
        }
    }
}

