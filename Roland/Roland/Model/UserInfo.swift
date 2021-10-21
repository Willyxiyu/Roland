//
//  UserInfo.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//

import Foundation
import Firebase

struct UserInfo: Codable {
    let name: String
    let gender: String
    let birth: String
    let phoneNumber: Int64?
    let photo: String?
    let userId: String?
    let createTime: Timestamp
    let appleidAccessToken: String?
    let block: Bool?
    let friendList: [FriendList]?
    let accountState: Bool?
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case birth
        case phoneNumber
        case photo
        case userId
        case createTime
        case appleidAccessToken
        case block
        case friendList
        case accountState
    }
    var toDict: [String: Any] {
        return [
            "name": name as Any,
            "gender": gender as Any,
            "birth": birth as Any,
            "phoneNumber": phoneNumber as Any,
            "photo": photo as Any,
            "userId": userId as Any,
            "createTime": createTime as Any,
            "appleidAccessToken": appleidAccessToken as Any,
            "block": block as Any,
            "friendList": friendList as Any,
            "accountState": accountState as Any
        ]
    }
}
struct FriendList: Codable {
    let userId: String?
    enum CodingKeys: String, CodingKey {
        case userId
    }
    var toDict: [String: Any] {
        return ["userId": userId as Any]
    }
}
