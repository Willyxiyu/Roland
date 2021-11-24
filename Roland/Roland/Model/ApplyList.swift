//
//  ApplyList.swift
//  Roland
//
//  Created by 林希語 on 2021/11/2.
//

import Foundation
import Firebase

struct ApplyList: Codable {
    let eventId: String
    let requestSenderId: String
    let acceptedId: String
    let documentId: String

    enum CodingKeys: String, CodingKey {
        case eventId
        case requestSenderId
        case acceptedId
        case documentId
    }
    
//    static let `default` = ApplyList(eventId: "", requestSenderId: "", acceptedId: "", documentId: "")
}

