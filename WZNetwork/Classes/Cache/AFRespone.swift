//
//  AFRespone.swift
//  Created by ___ORGANIZATIONNAME___ on 2024/2/4
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Foundation
import Cache

// MARK - 返回数据
public final class AFRespone: CustomDebugStringConvertible, Equatable {

    /// The status code of the response.
    public let statusCode: Int

    /// The response data.
    public let data: Data

    /// The original URLRequest for the response.
    public let request: URLRequest?

    /// The HTTPURLResponse object.
    public let response: HTTPURLResponse?

    public init(statusCode: Int, data: Data, request: URLRequest? = nil, response: HTTPURLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
    }

    /// A text description of the `Response`.
    public var description: String {
        "Status Code: \(statusCode), Data Length: \(data.count)"
    }

    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String { description }

    public static func == (lhs: AFRespone, rhs: AFRespone) -> Bool {
        lhs.statusCode == rhs.statusCode
            && lhs.data == rhs.data
            && lhs.response == rhs.response
    }
}

/// MARK - 扩展数据
extension TransformerFactory {
    static func forAFRespone<T: AFRespone>(_ type : T.Type) -> Transformer<T> {
        let toData: (T) throws -> Data = { $0.data }
        let fromData: (Data) throws -> T = {
            T(statusCode:  WZStatusCode.cache.rawValue, data: $0)
        }
        return Transformer<T>(toData: toData, fromData: fromData)
    }
}

