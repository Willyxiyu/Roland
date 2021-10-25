//
//  ChatRoomList.swift
//  Roland
//
//  Created by 林希語 on 2021/10/25.
//
import Foundation
import Firebase

struct ChatRoomList: Codable {
    let chatRoomId: String?
    let accepterId: String?
    let isBlock: Bool?
    let isDelete: Bool?
    let isTurnOn: Bool?
    
    enum CodingKeys: String, CodingKey {
        case chatRoomId
        case accepterId
        case isBlock
        case isDelete
        case isTurnOn
    }
}

// lateMessageId base on the ChatRoomID
struct LatestMessage: Codable {
    let createTime: Timestamp?
    let isRead: Bool?
    let latestMessage: String?
    enum CodingKeys: String, CodingKey {
        case createTime
        case isRead
        case latestMessage
    }
}
