//
//  Response+.swift
//  Created by CocoaPods on 2024/2/2
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Foundation
import CleanJSON
import Moya
import Swift

struct MyModel {
    
}

extension Response {
    
    
    
    
    func mapResult<T: Decodable>(_ type: T.Type) async throws -> WZResult<T> {
        return try await withUnsafeContinuation { continuation in
            
        
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type) ->Result<WZResult<T>, Error> {
        guard let cacheResponse = try? CleanJSONDecoder().decode(WZResult<T>.self, from: self.data) else {
            return .failure(NSError(domain: "解析错误", code: 500))
        }
        return .success(cacheResponse)
    }
}

