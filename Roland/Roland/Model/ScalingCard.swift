//
//  ScalingCard.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//

import Foundation
import Firebase

 struct ScalingCard: Codable {
    let senderId: String?
    let accepterId: String?
    let isLike: Bool?
    let createTime: Timestamp
     
    enum CodingKeys: String, CodingKey {
        case senderId
        case accepterId
        case isLike
        case createTime
    }
}
