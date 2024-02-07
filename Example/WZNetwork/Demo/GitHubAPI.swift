//
//  GitHubAPI.swift
//  Created by CocoaPods on 2024/2/2
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//
import Moya
import Foundation
import WZNetwork

enum GitHubAPI {
    case downloadConfig
}

// 实现 TargetType 协议来定义请求的详细信息
extension GitHubAPI: AFTargetType {

    var cacheType: WZNetwork.WZCacheKeyType {
        return .default
    }
    
    var parameters: [String : Any] {
        return ["token": ""]
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var baseURL: URL {
        return URL(string: "https://api.liangyuan.com")!
    }
    var path: String {
        switch self {
        case .downloadConfig:
            return "/center/app/config/getIOS"
        }
    }
    var method: HTTPMethod { return .get }
   
    var headers: [String : String]? { return nil }
}


