//
//  GroupEvent.swift
//  Roland
//
//  Created by 林希語 on 2021/10/28.
//

import Foundation
import Firebase
import FirebaseFirestore
import RealmSwift

struct GroupEvent: Codable {
    var senderId: String
    var eventId: String
    var createTime: Timestamp
    var eventPhoto: String
    var title: String
    var startTime: String
    var endTime: String
    var location: String
    var maximumOfPeople: Int
    var info: String
    var isClose: Bool
    var isPending: Bool
    var isFull: Bool
    var comment: [Comment]?
    var privateComment: [PrivateComment]?
    var host: [String]?
    var attendee: [String]?
    
    enum CodingKeys: String, CodingKey {
        case senderId
        case eventId
        case createTime
        case eventPhoto
        case title
        case startTime
        case endTime
        case location
        case maximumOfPeople
        case info
        case isClose
        case isPending
        case isFull
        case comment
        case privateComment
        case host
        case attendee
    }
    
}

struct Comment: Codable {
    var comment: String
    var commentSenderId: String
    var createTime: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case comment
        case commentSenderId
        case createTime
    }
}

struct PrivateComment: Codable {
    var comment: String
    var commentSenderId: String
    var createTime: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case comment
        case commentSenderId
        case createTime
    }
}
