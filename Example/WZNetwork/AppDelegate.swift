//
//  AppDelegate.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import UIKit
import Moya
import WZUUID
import WZNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        networkConfig()

        return true
    }
    
    
    
    /// 网络配置
    private func networkConfig() {
        
        Network.Configuration.default.timeoutInterval = 30
        Network.Configuration.default.publicParameters = { target -> [String: String] in
            return  ["request_agent": "ios",
                     "imei": WZUUID.uuid,
                     "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "4.0.0",
                     "token": ""]
        }
        
        Network.Configuration.default.addingHeaders = { _ in
            return defaultHTTPHeaders
        }
        
        Network.Configuration.default.cacheUserId = { _ in
            return "1223"
        }
        
//        Network.Configuration.default.publicParameters = ["request_agent": "ios",
//                                                          "imei": WZUUID.uuid,
//                                                          "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "4.0.0"]
        Network.Configuration.default.plugins = [NetworkIndicatorPlugin()]
        Network.Configuration.default.replacingTask = { target in
            
//            var totenParameters: [String: Any] = [:]
//            if let temToken = Network.Configuration.default.token {
//                totenParameters = ["token": temToken]
//            }
            switch target.task {
            case let .requestParameters(parameters, encoding):
                return .requestParameters(parameters: parameters.merge(withDictionary: target.publicParameters), encoding: encoding)
            case .requestPlain:
                return .requestParameters(parameters: target.publicParameters, encoding: URLEncoding.default)
            case let .uploadCompositeMultipart(multipartFormData, urlParameters):
                return .uploadCompositeMultipart(multipartFormData, urlParameters: urlParameters.merge(withDictionary: target.publicParameters))
            default:
                return target.task
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/// 自定义
private let defaultHTTPHeaders: [String: String] = {
    
    let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
    let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
        let quality = 1.0 - (Double(index) * 0.1)
        return "\(languageCode);q=\(quality)"
    }.joined(separator: ", ")
    
    let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                let model = UIDevice.current.model
                let systemVersion = UIDevice.current.systemVersion
                let scale = UIScreen.main.scale
                let osName: String = {
#if os(iOS)
                    return "iOS"
#elseif os(watchOS)
                    return "watchOS"
#elseif os(tvOS)
                    return "tvOS"
#elseif os(macOS)
                    return "OS X"
#elseif os(Linux)
                    return "Linux"
#else
                    return "Unknown"
#endif
                }()

                return "\(osName) \(versionString)"
            }()
            let executableName = executable
            return "\(executableName)/\(appVersion) (\(bundle); build:\(appBuild))"
        }
        return "WZNetworking"
    }()
    return ["Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent,
            "X-Channel-Code": ""]
}()
