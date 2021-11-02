//
//  GroupEvent.swift
//  Roland
//
//  Created by 林希語 on 2021/10/28.
//

import Foundation
import Firebase
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
//    var applyList: [String: ApplyList]?
    
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
//        case applyList
    }
    
}

//struct ApplyList: Codable {
//    let isAccepted: Bool
//    let isPending: Bool
//    let isRejected: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case isAccepted
//        case isPending
//        case isRejected
//    }
//}
