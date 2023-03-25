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
    func request() -> Single<Moya.Response> {
        return Network.default.provider
            .rx
            .request(.target(self))
            .observeOn(MainScheduler.instance)
    }
    
    /// 公有参数
    var publicParameters: [String : String] {
        return Network.Configuration.default.publicParameters(self)
    }
    
    /// 是否加密
    var isEncryption: Bool {
        if let mTarget = self as? MultiTarget,
            let encryption = mTarget.target as? EncryptionProtocol {
            return encryption.isEncryption
        }
        return false
    }
}



