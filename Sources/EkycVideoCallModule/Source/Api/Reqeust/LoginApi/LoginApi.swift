//
//  LoginApi.swift
//  VideoCallDemo
//
//  Created by Tùng Anh Nguyễn on 22/02/2022.
//

import Foundation

class LoginApi: BaseRequest {    
    var url: String = AppConsts.loginUrl
    var method: RequestMethod = .post
    var body: LoginReqeustModel = LoginReqeustModel(username: AppConsts.username, password: AppConsts.password)
    func parseData(data: Data) throws -> LoginResponse {
        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
    typealias Response = LoginResponse
    typealias Request = LoginReqeustModel
}

struct LoginReqeustModel: Codable {
    var username: String
    var password: String
}
