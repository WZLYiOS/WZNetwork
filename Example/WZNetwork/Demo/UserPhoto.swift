//
//  UserPhoto.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/4.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation


/// MARK - 用户照片库
struct UserPhoto: Decodable {
    
    /// 用户Id
    let userId: String
    
    /// 照片Id
    let photoid: String
    
    /// 缩图路径
    let thumbfiles: String
    
    /// 上传路径
    let uploadfiles: String
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case photoid = "photoid"
        case thumbfiles = "thumbfiles"
        case uploadfiles = "uploadfiles"
    }
}
