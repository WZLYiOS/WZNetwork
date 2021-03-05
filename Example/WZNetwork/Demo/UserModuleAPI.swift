//
//  UserModuleAPI.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Moya
import Foundation


/// MARK - 账户模块API
enum UserModuleApi {
    
    /// 登录
    case login(info: [String: Any])
    /// 获取相册
    case findalbum
    
    /// 上传用户头像
    case upLoadUserAvatar(info: [String: Any], image: Data)
    
    /// 下载配置
    case downloadConfig
}


// MARK: - TargetType
extension UserModuleApi: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://v4malu2x.api.7799520.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/passport/app/login/index"
        case .findalbum:
            return "/user/app/album/get"
        case .upLoadUserAvatar:
            return "/user/app/avatar/saveImg"
        case .downloadConfig:
            return "/center/app/config/getIOS"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .findalbum:
            return .get
        case .upLoadUserAvatar:
            return .post
        case .downloadConfig:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .login(info):
            return Task.requestParameters(parameters: info, encoding: URLEncoding.default)
        case .findalbum:
            return Task.requestPlain
        case let .upLoadUserAvatar(info, image):
            return Task.uploadCompositeMultipart([MultipartFormData(provider: MultipartFormData.FormDataProvider.data(image), name: "imgfile0", fileName: "20190901213123FromIOS.jpg", mimeType: "image/jpg")], urlParameters: info)
        case .downloadConfig:
            return Task.requestPlain
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
}
