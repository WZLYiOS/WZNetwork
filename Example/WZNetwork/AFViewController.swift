//
//  AFViewController.swift
//  Created by CocoaPods on 2024/2/4
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

import UIKit
import WZNetwork
import Alamofire

class AFViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AF.request("https://httpbin.org/get").responseJSON { response in
            switch response.result {
            case .success(let value):
                print("请求成功：\(value)")
            case .failure(let error):
                print("请求失败：\(error)")
            }
        }
        test()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func test() {
    
    }
}

enum AFTestApi {

    case getUserInfo(username: String)
}

extension AFTestApi: AFTargetType {
    
    
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case .getUserInfo(let username):
            return "/users/\(username)"
        }
    }
    
    var method: Alamofire.HTTPMethod{ return .get }
        
    var parameters: [String : Any] {
        return [:]
    }
    
    var encoding: Alamofire.ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers: [String : String]? {
        return nil
    }
}


struct AFUserInfo: Codable {
    
    let name: String
}
