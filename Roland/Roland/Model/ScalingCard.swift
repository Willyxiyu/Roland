//
//  ScalingCard.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//

import Foundation

 struct ScalingCard: Codable {
    let senderId: String
    let accepterId: String
    let state: Bool
    let createTime: String
    enum CodingKeys: String, CodingKey {
        case senderId
        case accepterId
        case state
        case createTime
    }
    var toDict: [String: Any] {
        return [
            "senderId": senderId as Any,
            "accepterId": accepterId as Any,
            "state": state as Any,
            "createTime": createTime as Any
        ]
    }
}
