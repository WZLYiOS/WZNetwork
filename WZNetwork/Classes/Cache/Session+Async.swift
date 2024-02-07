//
//  Session+Async.swift
//  Created by ___ORGANIZATIONNAME___ on 2024/2/4
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import Alamofire
import Foundation
import Cache

// MARK - 扩展
public extension Session {
    
    private struct AssociatedKey {
        static var storageKey: String = "AssociatedKey.Session.location.storage.key"
    }

    /// 缓存对象
    var storage: WZCacheStorage<AFRespone>? {
        get {
            guard let s = objc_getAssociatedObject(self, AssociatedKey.storageKey) as? WZCacheStorage<AFRespone> else {
                self.storage = WZCacheStorage<AFRespone>(transformer: TransformerFactory.forAFRespone(AFRespone.self))
                return self.storage
            }
            return s
        }
        set {
            objc_setAssociatedObject(self, AssociatedKey.storageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


