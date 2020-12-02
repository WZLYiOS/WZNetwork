//
//  JSONParsing.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/4.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import UIKit
import WZMoya
import RxSwift
import CleanJSON
import Foundation


/// MARK - 服务端统一返回实体
public struct WZResult<T: Decodable>: Decodable {
    let code: Int
    let msg: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case msg = "msg"
        case data = "data"
    }
}


// MARK: - PrimitiveSequence + JSONParsing
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    /// MARK - 转换数据为Result实体
    ///
    /// - Parameter type: 类型
    /// - Returns: Result
    func mapResult<T: Decodable>(_ type: T.Type) -> Observable<WZResult<T>> {
        
        return asObservable()
            .filterSuccessfulStatusCodes()
            .map { response in
                
                #if DEBUG
                do {
                    _ = try CleanJSONDecoder().decode(WZResult<T>.self, from: response.data)
                } catch {
                    debugPrint(error)
                }
                #endif
                
                guard let model = try? CleanJSONDecoder().decode(WZResult<T>.self, from: response.data) else {
                    throw NSError(domain: "解析错误", code: -9001, userInfo: nil)
                }
                return model
        }
    }
    
    
    /// 转换为单独的实体
    ///
    /// - Parameter type: <#type description#>
    /// - Returns: <#return value description#>
    func mapModel<T: Decodable>(_ type: T.Type) -> Observable<T> {
        
        return mapResult(T.self)
            .map { result -> T in
                
                guard result.code == 0 else {
                    throw NSError(domain: result.msg, code: result.code, userInfo: nil)
                }
                
                guard let temData = result.data else {
                    throw NSError(domain: "data数据为空", code: -9002, userInfo: nil)
                }
                return temData
        }
    }
    
    
    /// 可选实体
    ///
    /// - Parameter type: 类型
    /// - Returns: 可选实体的对象
    func mapOptionalModel<T: Decodable>(_ type: T.Type) -> Observable<T?> {
        
        return mapResult(T.self)
            .map { result -> T? in
                
                guard result.code == 0 else {
                    throw NSError(domain: result.msg, code: result.code, userInfo: nil)
                }
                return result.data
        }
    }
    
    
    /// 判断成功
    ///
    /// - Returns: 观察者成功
    func mapSuccess() -> Observable<Bool> {
        
        return mapResult(String.self)
            .map { result -> Bool in
                
                guard result.code == 0 else {
                    throw NSError(domain: result.msg, code: result.code, userInfo: nil)
                }
                return true
        }
    }
    
}
