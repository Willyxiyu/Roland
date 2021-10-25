//
//  ChatRoom.swift
//  Roland
//
//  Created by 林希語 on 2021/10/25.
//

import Foundation
import Firebase

struct ChatRoom: Codable {
    let createTime: Timestamp?
    let accepterId: String?
    let isRead: Bool?
    let senderId: String?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case createTime
        case accepterId
        case senderId
        case isRead
        case text
    }
}
