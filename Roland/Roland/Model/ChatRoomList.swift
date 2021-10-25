//
//  ChatRoomList.swift
//  Roland
//
//  Created by 林希語 on 2021/10/25.
//
import Foundation
import Firebase
import SwiftUI
import MessageKit

struct ChatRoomList: Codable {
    let userId: [UserId]
    let isBlock: Bool?
    let isDelete: Bool?
    let isTurnOn: Bool?
    let latestMessage: [LatestMessage]
    let chatRoomId: String
    
    enum CodingKeys: String, CodingKey {
        case chatRoomId
        case isBlock
        case isDelete
        case isTurnOn
        case latestMessage = "LatestMessage"
        case userId
    }
}

struct UserId: Codable {
    let senderId: String?
    let accepterId: String?
    
    enum CodingKeys: String, CodingKey {
        case senderId
        case accepterId
    }
}

// lateMessageId base on the ChatRoomID
struct LatestMessage: Codable {
    let date: String?
    let isRead: Bool?
    let latestMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case isRead
        case latestMessage
    }
}
