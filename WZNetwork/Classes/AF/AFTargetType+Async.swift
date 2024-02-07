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
import Combine
import Cache

// MARK - 扩展
public extension AFTargetType {
    
    /// 请求头
    private var header: HTTPHeaders? {
        if let h = self.headers {
            return HTTPHeaders(h)
        }
        return nil
    }
    
    /// 获取缓存路径
    func getCacheKey(_ type: WZCacheKeyType) -> String {
        switch type {
        case .default:
            return baseURL.absoluteString + path + "?\(parameters)"
        case .base:
            return baseURL.absoluteString + path
        case .custom(let string):
            return baseURL.absoluteString + path + string
        }
    }
    
    /// 获取请求数据
    private var dataRequest: DataRequest {
        return Session.default.request("\(self.baseURL)\(self.path)", method: self.method, parameters: self.parameters, encoding: self.encoding, headers: header)
    }
    
    /// 获取
    private func getCacheKey(ignore: [String]) -> String {
        var dic = parameters
        ignore.forEach {
            dic.removeValue(forKey: $0)
        }
        return MD5(baseURL.absoluteString + path + "?\(dic)")
    }
    
    /// 请求数据
    func request(_ policyType: CachePolicyType = .nomar, ignore: [String] = []) async throws -> AsyncStream<AFRespone> {
        return AsyncStream { continuation in
                Task {
                    switch policyType {
                    case .nomar:
                        continuation.yield(try await respone())
                    case .cache:
                        let key = getCacheKey(ignore: ignore)
                        if let cache = Session.default.storage?.object(forKey: key) {
                            continuation.yield(cache)
                        }
                        continuation.yield(try await respone(key: key))
                    case .cacheElseLoad:
                        let key = getCacheKey(ignore: ignore)
                        if let cache = Session.default.storage?.object(forKey: key){
                            continuation.yield(cache)
                        }else{
                            continuation.yield(try await respone(key: key))
                        }
                    }
                    continuation.finish() 
                }
            }
    }
    
    /// 服务端返回结果
    func respone(key: String = "") async throws -> AFRespone {
        return try await withUnsafeThrowingContinuation { continuation in
            dataRequest.responseData { respone in
                switch respone.result {
                case .success(let success):
                    let result = AFRespone(statusCode: respone.response!.statusCode, data: success, request: respone.request, response: respone.response)
                    if key.count > 0 {
                        Session.default.storage?.setObject(result, forKey: key)
                    }
                    continuation.resume(returning: result)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
}
