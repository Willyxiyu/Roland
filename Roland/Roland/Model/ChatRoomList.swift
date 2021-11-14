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
    let userId: [String]
    let isBlock: Bool?
    let isDelete: Bool?
    let isTurnOn: Bool?
    let latestMessage: LatestMessage
    let chatRoomId: String?
    let messagelist: [Messagelist]?
    
    enum CodingKeys: String, CodingKey {
        case chatRoomId
        case isBlock
        case isDelete
        case isTurnOn
        case latestMessage
        case userId
        case messagelist
    }
}
// lateMessage is for the chatlist label
struct LatestMessage: Codable {
    let createTime: Timestamp?
    let isRead: Bool?
    let text: String?
    let accepterId: String?
    let senderId: String?

    enum CodingKeys: String, CodingKey {
        case createTime
        case isRead
        case text
        case accepterId
        case senderId
    }
}
// chat messagelist are collect in the Chatroomlist
struct Messagelist: Codable {
    let createTime: Timestamp?
    let isRead: Bool?
    let text: String?
    let accepterId: String?
    let senderId: String?
    let photoMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case createTime
        case isRead
        case text
        case accepterId
        case senderId
        case photoMessage
    }
}
