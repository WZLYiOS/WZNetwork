//
//  BaseConfigInfo.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/4.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation


/// 基础配置信息
struct BaseConfigInfo: Decodable {
    
    /// 血型
    let blood: [BaseConfigModel]
    
    /// 所在行业
    let profession: [BaseConfigModel]
    
    enum CodingKeys: String, CodingKey {
        case blood = "blood"
        case profession = "profession"
    }
}




/// 基础配置实体
struct BaseConfigModel: Decodable {
    
    /// id
    let id: Int
    
    /// 名称
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
