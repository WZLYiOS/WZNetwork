//
//  TargetType+Rx.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Moya
import RxSwift




// MARK: - TargetType + Rx
public extension TargetType {
    
    /// 请求
    ///
    /// - Returns: Single<Moya.Response>
    func request(policyType: CachePolicyType = .nomar, cacheType: WZCacheKeyType = .default) -> Observable<Moya.Response> {
        return Network.default.provider
            .rx
            .cacheRequest(.target(self), responseCache: policyType, cacheType: cacheType)
            .observe(on: MainScheduler.instance)
    }

    /// 公有参数
    var publicParameters: [String : String] {
        return Network.Configuration.default.publicParameters(self)
    }
    
    // 是否加密
    var isEncryption: Bool {
        if let mTarget = self as? MultiTarget,
            let encryption = mTarget.target as? EncryptionProtocol {
            return encryption.isEncryption
        }
        return false
    }
}

// MARK - 扩展
public extension Reactive where Base: MoyaProviderType {
    
    /**
     缓存网络请求:
     
     - 如果本地无缓存，直接返回网络请求到的数据
     - 如果本地有缓存，先返回缓存，再返回网络请求到的数据
     - 只会缓存请求成功的数据（缓存的数据 response 的状态码为 MMStatusCode.cache）
     - 适用于APP首页数据缓存
     
     */
    func cacheRequest(_ target: Base.Target, responseCache: CachePolicyType = .nomar, callbackQueue: DispatchQueue? = nil, cacheType: WZCacheKeyType = .default) -> Observable<Response> {

        switch responseCache {
        case .nomar:
            return request(target, callbackQueue: callbackQueue).asObservable()
        case .cacheElseLoad:
            if let cacheResponse = target.fetchResponseCache(cacheType: cacheType) {
                return Observable.just(cacheResponse)
            }
            return request(target, callbackQueue: callbackQueue).asObservable()
        case .cache:
            var originRequest = request(target, callbackQueue: callbackQueue).asObservable()
            let cacheResponse = target.fetchResponseCache(cacheType: cacheType)
            // 更新缓存
            originRequest = originRequest.map { response -> Response in
                if let resp = try? response.filterSuccessfulStatusCodes() {
                    target.setResponse(cacheType: cacheType, respone: resp)
                }
                return response
            }
            guard let lxf_cacheResponse = cacheResponse else {
                return originRequest
            }
            return Observable.just(lxf_cacheResponse).concat(originRequest)
        }
    }
    
    
}

