//
//  LoginResponse.swift
//  VideoCallDemo
//
//  Created by Tùng Anh Nguyễn on 22/02/2022.
//

import Foundation

class LoginResponse: Codable {
    var sessionid: String!
    var voiceUser: String!
    var voiceDomain: String!
    
    enum CodingKeys: String, CodingKey {
        case sessionid = "sessionid"
        case voiceUser = "voiceUser"
        case voiceDomain = "voiceDomain"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sessionid = try values.decode(String.self, forKey: .sessionid)
        voiceUser = try values.decode(String.self, forKey: .sessionid)
        voiceDomain = try values.decode(String.self, forKey: .sessionid)
    }
    
//    override init(json: JSON) {
//        super.init(json: json)
//
//        sessionid = json["sessionid"].stringValue
//        voiceUser = json["voiceUser"].stringValue
//        voiceDomain = json["voiceDomain"].stringValue
//
//    }
}
