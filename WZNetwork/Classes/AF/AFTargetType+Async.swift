//
//  AFTargetType+Async.swift
//  Created by ___ORGANIZATIONNAME___ on 2024/2/4
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Foundation
import Alamofire

// MARK - 扩展
public extension AFTargetType {
    
    /// 请求头
    private var header: HTTPHeaders? {
        if let h = self.headers {
            return HTTPHeaders(h)
        }
        return nil
    }
    
    private var dataRequest: DataRequest {
        return AF.request("\(self.baseURL)\(self.path)", method: self.method, parameters: self.parameters, encoding: self.encoding, headers: header)
    }
        
    /// 请求数据
    func request<T: Decodable>(type: T.Type, decoder: DataDecoder = JSONDecoder()) async throws -> T {
        return try await withUnsafeThrowingContinuation { continuation in
            dataRequest.responseDecodable(of: type, decoder: decoder) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
