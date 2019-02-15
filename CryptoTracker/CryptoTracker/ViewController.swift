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
    var coinList: [CoinName]?
    var sortedCoinList: [CoinName]?
    var filterdCoinList: [CoinName]?
    var isSearching: Bool = false
    var imageDict = [String : UIImage?]()
    var isPrefetching = false
    
    //@IBOutlet weak var coinListPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCryptoData()
        tableView.prefetchDataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func loadCryptoData() {
        cryptoTrackerData.getCoinList() { (coinList) in
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
        let topIndex = IndexPath(row: 0, section: 0)
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
            view.endEditing(true)
        } else {
            isSearching = true
            isPrefetching  = true
            filterdCoinList = coinList?.filter({$0.CoinName.localizedCaseInsensitiveContains(searchBar.text!)})
            tableView.reloadData()
        }
        
        if(filterdCoinList?.count != 0) {
            tableView.scrollToRow(at: topIndex, at: .top, animated: true)
            tableView.reloadData()
        }
    }
    
    //TableViewDelegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let coins = isSearching ? filterdCoinList?.count : coinList?.count
        return coins!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let myCell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath)
        
        guard var coinList = isSearching ? filterdCoinList : coinList else { fatalError() }
        coinList = coinList.sorted { $0.CoinName < $1.CoinName }
        self.sortedCoinList = coinList

        myCell.textLabel?.text = "\(coinList[indexPath.row].CoinName)"
        
        if let myImage = imageDict[coinList[indexPath.row].CoinName] {
            myCell.imageView?.image = myImage
        } else {
            let url = URL(string: "https://www.cryptocompare.com\(coinList[indexPath.row].ImageUrl!)")
            let data = try? Data(contentsOf: url!)
            imageDict[coinList[indexPath.row].CoinName] = UIImage(data: data!)
            myCell.imageView?.image = UIImage(data: data!)
        }
       
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCryptoInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CryptoCoinInformationViewController {
            destination.coin = sortedCoinList![(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        isPrefetching = true
        guard var coinList = sortedCoinList else {fatalError()}
        indexPaths.forEach {
            let coinName = coinList[$0.row].CoinName
            self.cryptoTrackerData.getImageFromUrl(imageURL: coinList[$0.row].ImageUrl!, completionHandler: { (Data) in
                self.imageDict[coinName] = UIImage(data: Data)
            })
        }
        isPrefetching = false
    }
}

