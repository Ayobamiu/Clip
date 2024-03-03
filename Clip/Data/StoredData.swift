//
//  StoredData.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import Foundation
//let storedData1:Item = {
//    title: "Username", textValue: "john_doe", dataType: .text, isValueHidden: false
//}

var jsjs: [Item] = []

for i in 0..<5 {
    let newItem:Item
    newItem.timestamp = Date()
    newItem.textValue = "Random Value \(i)"
    newItem.isValueHidden = i % 2 == 0
    newItem.title = "Random Title \(i)"
    
    jsjs.append(newItem)
}
