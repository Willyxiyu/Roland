//
//  Firebase.swift
//  Roland
//
//  Created by 林希語 on 2021/10/20.
//
import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class FirebaseManger {
    
    static let shared = FirebaseManger()
    lazy var database = Firestore.firestore()
    
    var users = [UserInfo]()
    var chatRoomList = [ChatRoomList]()
    var messagelist = [Messagelist]()
    var applyList = [ApplyList]()
    var groupEvent = [GroupEvent]()
    var message = ""
    var senderId = ""
    var accepterId = ""
}
