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
struct UserInfo: Codable {
    
    let name: String
}


enum GitHubAPI {
    case getUserInfo(username: String)
}

// 实现 TargetType 协议来定义请求的详细信息
extension GitHubAPI: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .getUserInfo(let username):
            return "/users/\(username)"
        }
    }
    var method: Moya.Method { return .get }
    var task: Task { return .requestPlain }
    var headers: [String : String]? { return nil }
}


