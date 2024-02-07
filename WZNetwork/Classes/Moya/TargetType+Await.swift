//
//  TargetType+Await.swift
//  Created by ___ORGANIZATIONNAME___ on 2024/2/2
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Foundation
import Moya

// 扩展moya
public extension TargetType {
    
    // 请求缓存类型
    func request(policyType: CachePolicyType = .nomar, cacheType: WZCacheKeyType = .default) async throws -> Response {
        return try await cacheRequest(policyType: policyType, cacheType: cacheType)
    }
    
    /// 从服务端获取数据
    private func request() async throws -> Moya.Response {
        return try await withUnsafeThrowingContinuation { continuation in
            let provider = Network.default.provider
            provider.request(.target(self)) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 根据缓存策略获取数据
    private func cacheRequest(policyType: CachePolicyType, cacheType: WZCacheKeyType) async throws -> Response{
        
        switch policyType {
        case .nomar:
            return try await request()
        case .cacheElseLoad:
            if let cacheResponse = fetchResponseCache(cacheType: cacheType) {
                return cacheResponse
            }
            return try await request()
        case .cache:
        
            /// 缓存数据
            let cacheResponse = fetchResponseCache(cacheType: cacheType)
            
            /// 向服务端请求的数据
            let requestResponse = try await request()
        
            /// 保存服务端返回的数据
            if let resp = try? requestResponse.filterSuccessfulStatusCodes() {
                self.setResponse(cacheType: cacheType, respone: resp)
            }
            
            guard let lxf_cacheResponse = cacheResponse else {
                return requestResponse
            }
            return requestResponse
        }
    }
}


