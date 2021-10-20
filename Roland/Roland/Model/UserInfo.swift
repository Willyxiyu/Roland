//
//  UserInfo.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//

import Foundation

struct UserInfo: Codable {
    let name: String
    let gender: String
    let birth: String
    let phoneNumber: Int64
    let userId: String
    let createTime: String
    let appleidAccessToken: String
    let block: Bool
    let friendList: [FriendList]
    let accountState: String
    
    
    enum CodingKeys: String, CodingKey {
        
    }
    var toDict: [String: Any] {
        return [
        ]
    }
    
}

struct FriendList: Codable {
    let userId: String
}
