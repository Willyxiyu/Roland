//
//  UserInfo.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct UserInfo: Codable {
    let name: String
    let gender: String
    let age: String
    let email: String
    let createTime: Timestamp
    let phoneNumber: Int64?
    let intro: String?
    let photo: String?
    let userId: String?
    let accountState: Bool?
    let likeList: [String]?
    let dislikeList: [String]?
    let blockList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case age
        case phoneNumber
        case intro
        case photo
        case userId
        case createTime
        case accountState
        case email
        case likeList
        case dislikeList
        case blockList

    }
}

// todo: remove it
class SelfUser {

    static var userInfo: UserInfo?

}
