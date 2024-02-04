//
//  AFTargetType.swift
//  Created by ___ORGANIZATIONNAME___ on 2024/2/4
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Alamofire

public protocol AFTargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// Request parameters
    var parameters: [String: Any] { get }
    
    /// Encoding method
    var encoding: ParameterEncoding { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

