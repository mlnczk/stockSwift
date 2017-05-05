//
//  StocksViewController.swift
//  stock
//
//  Created by Marcin Mielniczek on 04.05.2017.
//  Copyright © 2017 Marcin Mielniczek. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel = StocksViewModel()
    @IBOutlet weak var tableView: UITableView!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "StocksTableViewCell", bundle: nil), forCellReuseIdentifier: "StocksTableViewCell")
        
        self.startTimer()
        
        NotificationCenter.default.addObserver(self, selector:#selector(appBG) , name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appFG), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appBG() {
        self.timer.invalidate()
        NSLog("app in bg")
    }
    
    func appFG() {
        self.startTimer()
        NSLog("app in fg")
    }
    
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.loadData), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    func loadData() {
        self.viewModel.getStocks { (success) -> (Void) in
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as! StocksTableViewCell
        
        cell.customizeWithStock(stock: self.viewModel.dataArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
