//
//  UserModel.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/4.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

/// 用户信息
struct UserModel: Decodable {
    
    /// 用户Id
    let userId: String
    
    /// 用户Token
    let token: String
    
    /// 是否显示新人推荐,1:显示, 0不显示
    let isShowNew: Bool
    
    /// 是否上传形象照，1上传，0未上传
    let isAvatar: Bool
    
    /// 是否上传一级兴趣爱好，1已上传，0未上传
    let isInterest: Bool
    
    /// 是否需要变更名字 0不需要 1 需要
    let isChangenName: Int
    
    /// 腾讯云通信签名
    let userTXSig: String
    
    /// 是否有礼包
    let isGift: Bool
    
    /// 是否是官方账号
    let isOfficial: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case token = "token"
        case isShowNew = "showNew"
        case isAvatar = "is_avatar"
        case isInterest = "is_interest"
        case isChangenName = "nameStatus"
        case userTXSig = "userSig"
        case isGift = "has_spread_prize"
        case isOfficial = "is_official"
    }
}
