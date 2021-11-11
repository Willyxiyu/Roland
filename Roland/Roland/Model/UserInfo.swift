//
//  UserInfo.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//

import Foundation
import Firebase
import FirebaseFirestore

struct UserInfo: Codable {
    let name: String
    let gender: String
    let age: String
    let email: String
    let createTime: Timestamp
    let phoneNumber: Int64?
    let photo: String?
    let userId: String?
    let block: Bool?
    let friendList: [FriendList]?
    let accountState: Bool?
    let myEventId: [String]?
    let otherEventId: [String]?
    let likeList: [String]?
    let dislikeList: [String]?

    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case age
        case phoneNumber
        case photo
        case userId
        case createTime
        case block
        case friendList
        case accountState
        case myEventId
        case otherEventId
        case email
        case likeList
        case dislikeList

    }
    
}

struct FriendList: Codable {
    let userId: String?
    let isBlock: Bool?
    let isPending: Bool?
    enum CodingKeys: String, CodingKey {
        case userId
        case isBlock
        case isPending
    }
}
