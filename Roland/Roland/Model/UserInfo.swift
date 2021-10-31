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
    let createTime: Timestamp?
    let appleidAccessToken: String?
    let block: Bool?
    let friendList: [FriendList]?
    let accountState: Bool?
    let eventList: [EventList]?
    
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
        case eventList
    }
    
}
struct EventList: Codable {
    let eventId: String?
    enum CodingKeys: String, CodingKey {
        case eventId
    }
}

struct FriendList: Codable {
    let userId: String?
    enum CodingKeys: String, CodingKey {
        case userId
    }
}
