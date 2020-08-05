//
//  ViewController.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import UIKit
import WZMoya
import WZUUID
import RxSwift
import WZNetwork
import Foundation


/// MARK - 演示项目
final class ViewController: UIViewController {
    
    /// 列表
    private lazy var tableView: UITableView = {
         let temTableView = UITableView()
         temTableView.backgroundColor = UIColor.white
         temTableView.rowHeight = 50
         temTableView.separatorInset = .zero
         temTableView.tableFooterView = UIView()
         temTableView.dataSource = self
         temTableView.delegate = self
         temTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
         return temTableView
    }()
    
    
    /// 释放
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我主良缘网络请求例子"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModuleApi.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = UserModuleApi.allCases[indexPath.row].description
        return cell
    }
}


// MARK: - <#UITableViewDelegate#>
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let requestObject = UserModuleApi.allCases[indexPath.row]
        switch indexPath.row {
        case 0:
            requestObject.request()
                .mapModel(UserModel.self)
                .subscribe(onNext: { (result) in
                    debugPrint(result)
                    Network.Configuration.default.token = result.token
                }, onError: { (error) in
                    debugPrint(error)
                }).disposed(by: disposeBag)
        case 1:
            requestObject.request()
                .mapModel([UserPhoto].self)
                .subscribe(onNext: { (result) in
                    debugPrint(result)
                }, onError: { (error) in
                    debugPrint(error)
                }).disposed(by: disposeBag)
        case 2:
            requestObject.request()
                .mapResult(String.self)
                .subscribe(onNext: { (result) in
                debugPrint(result.msg)
            }, onError: { (e) in
                debugPrint(e)
            }).disposed(by: disposeBag)
        case 3:
            
            requestObject.request()
                .mapModel(BaseConfigInfo.self)
                .subscribe(onNext: { (result) in
                    debugPrint(result)
                }, onError: { (error) in
                    debugPrint(error)
                }).disposed(by: disposeBag)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - CaseIterable
extension UserModuleApi: CaseIterable, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .login:
            return "登录接口"
        case .findalbum:
            return "获取用户相册接口"
        case .upLoadUserAvatar:
            return "上传用户头像（已废弃，全部走七牛）"
        case .downloadConfig:
            return "下载配置文件"
        }
    }
    
    public static var allCases: [UserModuleApi] {
        
        return [.login(info: ["username": "13696888999",
                              "password": "123456",
                              "source": "iOS",
                              "system": UIDevice.current.systemVersion,
                              "version":  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "4.0.0",
                              "request_agent": "ios",
                              "imei": WZUUID.uuid,
                              "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "4.0.0"]
            .encryption),
                findalbum,
                upLoadUserAvatar(info: [:], image: UIImage(named: "Image1111")!.jpegData(compressionQuality: 0.8)!),
                downloadConfig]
    }
    
    
}



// MARK: - 加密编码
private extension Dictionary {
    
    /// 加密后的字典(这个接口比较特殊，只有登录有用到)
    var encryption: [String: Any] {
        
        var temDic: [String: Any] = [:]
        self.forEach { (result) in
            temDic["\(result.key)"] = WZDES3.encrypt("\(result.value)", key: "www.7799520.com/wzly/wZLy520?#@", iv: "01234567")
        }
        //加上版本号
        temDic["api_version"] = "2.1.1"
        return temDic
    }
}
