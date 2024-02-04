//
//  CacheManager.swift
//  Created by ___ORGANIZATIONNAME___ on 2024/2/4
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Cache
import Foundation
import UIKit

// MARK - cache
public class WZCacheStorage<Value> {
    
    /// 缓存对象
    public let responseStorage: Storage<String, Value>?
    
    /// 初始化
    public init(transformer: Transformer<Value>) {
        let diskConfig = DiskConfig(name: "WZCache.lxf.MoyaResponse")
        let memoryConfig = MemoryConfig()
        responseStorage = try? Storage<String, Value>(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: transformer)
    }
    
    /// 清除所有缓存
    ///
    /// - Parameter completion: completion
    func removeAllCache(completion: @escaping (_ isSuccess: Bool) -> ()) {
        responseStorage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    /// 根据key值清除缓存
    ///
    /// - Parameters:
    ///   - cacheKey: cacheKey
    ///   - completion: completion
    func removeObjectCache(_ cacheKey: String, completion: @escaping (_ isSuccess: Bool) -> ()) {
        responseStorage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    /// 读取缓存
    ///
    /// - Parameter key: key
    /// - Returns: model
    func object(forKey key: String) -> Value? {
        do {
            /// 过期清除缓存
            if let isExpire = try responseStorage?.isExpiredObject(forKey: key),
                isExpire
            {
                removeObjectCache(key) { _ in }
                debugPrint("读取缓存失败： - 缓存过期")
                return nil
            } else {
                debugPrint("读取缓存成功")
                return try responseStorage?.object(forKey: key)
            }
        } catch {
            debugPrint("读取缓存失败：- 无缓存")
            return nil
        }
    }
    
    /// 异步缓存
    ///
    /// - Parameters:
    ///   - object: model
    ///   - key: key
    func setObject(_ object: Value, forKey key: String, expiry: Expiry? = nil) {
        responseStorage?.async.setObject(object, forKey: key, expiry: nil, completion: { result in
            switch result {
            case .value:
                debugPrint("缓存成功")
            case .error(let error):
                debugPrint("缓存失败: \(error)")
            }
        })
    }
}

