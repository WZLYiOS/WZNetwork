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
import Swift
import WZNetwork
import Combine

extension AFRespone: CustomDecodable {
    
    /// MARK - 转换数据为Result实体
    ///
    /// - Parameter type: 类型
    /// - Returns: Result
    func mapResult<T: Decodable>(_ type: T.Type) throws -> WZResult<T> {
        
        guard let model = try? CleanJSONDecoder().decode(WZResult<T>.self, from: data) else {
            throw NSError(domain: "解析错误", code: -9001, userInfo: nil)
        }
        return model
    }
    
    /// 转换为单独的实体
    ///
    /// - Parameter type: <#type description#>
    /// - Returns: <#return value description#>
    func mapModel<T: Decodable>(_ type: T.Type) throws -> T {
        
        let result = try mapResult(type)
        guard result.code == 0 else {
            throw NSError(domain: result.msg, code: result.code, userInfo: nil)
        }
        guard let temData = result.data else {
            throw NSError(domain: "data数据为空", code: -9002, userInfo: nil)
        }
        return temData
    }
    
  
}

extension AsyncStream<AFRespone> {
    

    func mapModelStream<T: Decodable>(_ type: T.Type)async throws -> AsyncStream<T> {
        
        let aa = AsyncStream<T> { continuation in
               Task {
                   for await item in self {
                       continuation.yield(try item.mapModel(type))
                   }
                   continuation.finish()
               }
           }
        return aa
    }
    
  
    /// 获取数据
    func fetchData() async throws -> [AFRespone] {
       
        var responses: [AFRespone] = []
         for await response in self {
               // 在这里对每个 AFResponse 对象进行处理
               responses.append(response)
           }
        return responses
    }
}

protocol CustomDecodable {
    func mapModel<T: Decodable>(_ type: T.Type) throws -> T
}


