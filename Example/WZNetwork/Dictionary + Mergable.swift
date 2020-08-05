//
//  Dictionary + Mergable.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/4.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import UIKit
import Foundation


/// 合并协议
public protocol Mergable {
    func merge(withOther:Self) -> Self
}

// MARK: - 字典合并
public extension Dictionary where Value : Mergable {
    func merge(withDictionary: Dictionary) -> Dictionary {
        var returnDictionary = withDictionary
        for (key, value) in self {
            if let withDictionaryValue = withDictionary[key] {
                returnDictionary[key] = value.merge(withOther: withDictionaryValue)
            } else {
                returnDictionary[key] = value
            }
        }
        return returnDictionary
    }
}


// MARK: - <#Description#>
public extension Dictionary {
    func merge(withDictionary: Dictionary) -> Dictionary {
        var returnDictionary = withDictionary
        keys.forEach {returnDictionary[$0] = self[$0]}
        return returnDictionary
    }
}
