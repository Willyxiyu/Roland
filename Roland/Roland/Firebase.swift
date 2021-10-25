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

class FirebaseManger {
    static let shared = FirebaseManger()
    lazy var database = Firestore.firestore()
    
    var users = [UserInfo]()
    var chatRoomList = [ChatRoomList]()
    var message = ""
    var senderId = ""
    var accepterId = ""
    
    func addUserInfo() {
        let ref = database.collection("UserInfo")
        let docId = ref.document().documentID
        let userInfo: [String: Any] = [
            "name": "當男人戀愛時",
            "gender": "遊戲Boy",
            "birth": "26",
            "phoneNumber": 0910921921,
            "userId": docId,
            "createTime": Timestamp(date: Date())
        ]
        ref.document(docId).setData(userInfo) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(userInfo)")
            }
        }
    }
    func getUserInfoFromFirestore(completion: @escaping ([UserInfo]) -> Void) { // only needs name, birth
        database.collection("UserInfo").getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
                
                return
                
            } else {
                
                var users = [UserInfo]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let userInfo = try document.data(as: UserInfo.self) {
                            users.append(userInfo)
                            //                            print(users)
                        }
                        
                    } catch {
                        
                    }
                }
                
                completion(users)
            }
        }
    }
}

// MARK: - Sending messages / conversations
extension FirebaseManger {
    
    /// Creates a new conversation with target user email and first message sent
    public func createNewChatRoom(firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let ref = database.collection("ChatRoomList")
        let docId = ref.document().documentID
        let messageDate = firstMessage.sentDate
        guard let dateString = ChatRoomViewController.dateFormatter.string(for: messageDate) else {
            return
        }
        switch firstMessage.kind {
            
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let newChatRoomList: [String: Any] = [
            "chatRoomId": "ChatRoom_\(firstMessage.messageId)",
            "userId": [senderId, accepterId],
            "isBlock": false,
            "isDelete": false,
            "isTurnOn": true,
            "latestMessage": [
                "date ": dateString,
                "isRead": true,
                "latestMessage": message
            ]
        ]
        
        ref.whereField("userId", in: [[senderId], [accepterId]])
        
        // if senderId & accepterId 都有 {
        // { 直接開原有的聊天室
        // } else { 開新的聊天室
        
        ref.document(docId).setData(newChatRoomList) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(newChatRoomList)")
            }
        }
    }
    /// Fetches and returns all conversation for the users with passed in email
    public func getAllChatRoom(completion: @escaping([ChatRoomList]) -> Void) {
        
        database.collection("ChatRoomList").whereField("userId", in: [[senderId], [accepterId]])
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print(error)
                    
                    return
                } else {
                    var chatRoomList = [ChatRoomList]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let chatroom = try document.data(as: ChatRoomList.self) {
                                chatRoomList.append(chatroom)
                            }
                        } catch {
                            
                        }
                    }
                    
                    completion(chatRoomList)
                }
            }
    }
    
    /// Gets all messages for a given conversation
    public func getAllMessagesForChatRoom(chatRoomId: String, completion: @escaping(Result<String, Error>) -> Void) {
//        database.collection("ChatRoomList").document(chatRoomId).collection("message")
//            .getDocuments { querySnapshot, error in
//                if let error = error {
//                    print(error)
//                    return
//                } else {
////                    var messages = [message]()
//
//                    for document in querySnapshot!.documents {
//
//                        do {
//                            if let chatroom = try document.data(as: ChatRoomList.self) {
//                                message.append(messages)
//                            }
//                        } catch {
//
//                        }
//                    }
//
//                    completion(messages)
//                }
//            }
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
}
