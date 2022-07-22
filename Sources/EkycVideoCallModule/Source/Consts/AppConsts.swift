//
//  AppConsts.swift
//  VideoCallDemo
//
//  Created by Tùng Anh Nguyễn on 22/02/2022.
//

import Foundation

class AppConsts {
//https://113.161.71.83:8443/assistsample/?agent=sip:3333@10.138.139.18
    static let baseURl = "https://113.161.71.83"
    static let port = "8443"
    static let agent = "sip:3333@10.138.139.18"
    static let username = "1001"
    static let password = "123"
    
    static let loginUrl = "\(baseURl):\(port)/csdk-sample/SDK/login"
    static let logoutUrl = "\(baseURl):\(port)/csdk-sample/SDK/login/id"
}
