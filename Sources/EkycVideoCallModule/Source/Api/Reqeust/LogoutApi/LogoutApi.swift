//
//  LogoutApi.swift
//  VideoCallDemo
//
//  Created by Tùng Anh Nguyễn on 23/02/2022.
//

import Foundation

class LogoutApi: BaseRequest {
    typealias Response = ResponseModel
    typealias Request = RequestModel
    
    private var sessionId: String!
   
    init(sessionId: String) {
        self.sessionId = sessionId
    }

    var url: String { return  "\(AppConsts.logoutUrl)/\(sessionId!)" }
    var method: RequestMethod = .delete
    var body: RequestModel = RequestModel()
    func parseData(data: Data) throws -> ResponseModel {
        return ResponseModel()
    }
}
