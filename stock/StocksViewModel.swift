//
//  StocksViewModel.swift
//  stock
//
//  Created by Marcin Mielniczek on 04.05.2017.
//  Copyright © 2017 Marcin Mielniczek. All rights reserved.
//

import UIKit
import SwiftSoup

class StocksViewModel: NSObject {
    
    private var errorHandler = ErrorHandler()
    private var wordsArray: Array<String>!
    private var latestDataArray: [Stocks] = []
    
    private let nameArray: [String] = [NameDefines.WIG, NameDefines.WIG20, NameDefines.mWIG40, NameDefines.sWIG80]
    
    public var dataArray: [Stocks] = []
    
    func getStocks(completion: @escaping (Bool) -> (Void)) {
        ApiManager.sharedInstance.getOperation(action: ApiDefines.stocks, params: [:]) { (responseObject, success) -> (Void) in
            
            if (success) {
                if self.dataArray.count > 0 {
                    self.latestDataArray = self.dataArray
                    self.dataArray.removeAll()
                }
                do {
                    let doc = try SwiftSoup.parse(responseObject as! String)
                    var plainText = try doc.body()?.text()
                    
                    let index = plainText?.endIndex(of: otherDefines.off)
                    plainText = plainText?.substring(from: index!)
                    self.wordsArray = plainText?.components(separatedBy: " ")
                    
                    for name in self.nameArray {
                        self.addObjectIntoDataArray(name: name)
                    }
                    self.checkForChanges()
                    
                }catch {
                    self.errorHandler.createAlert(error: otherDefines.error)
                }
            }
            
            completion(success)
        }
    }
    
    func addObjectIntoDataArray(name: String) {
        var foundObject = false
        let stocksObject = Stocks()
        var updatedData = 0
        
        for (index,element) in self.wordsArray.enumerated() {
            
            if foundObject == true {
                if element.contains(":") && stocksObject.time == nil {
                    stocksObject.time = element
                    updatedData += 1
                }else if self.isNumeric(string: element) && stocksObject.value == nil {
                    stocksObject.value = element
                    updatedData += 1
                }
            }
            if self.wordsArray[index] == name && foundObject == false{
                foundObject = true
                stocksObject.name = element
                updatedData += 1
            }
            
            if updatedData == 3 {
                self.dataArray.append(stocksObject)
                break;
            }
        }
    }
    
    func isNumeric(string: String) -> Bool {
        let number = Float(string)
        return number != nil
    }
    
    func checkForChanges() {
        if self.latestDataArray.count == self.dataArray.count {
            for (index,element) in self.dataArray.enumerated() {
                let selectedLatestStock = self.latestDataArray[index]
                if element.value == selectedLatestStock.value {
                    element.wasChanged = false
                }else {
                    element.wasChanged = true
                }
            }
        }
    }
}
