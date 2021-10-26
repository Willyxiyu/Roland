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
    var messagelist = [Messagelist]()
    var message = ""
    var senderId = ""
    var accepterId = ""
    
    func addUserInfo() {
        let ref = database.collection("UserInfo")
        let docId = ref.document().documentID
        let userInfo: [String: Any] = [
            "name": "WillyBoy",
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
    
    /// Creates a new conversation with target userId and first message sent
    public func createNewChatRoom(with accepterId: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let ref = database.collection("ChatRoomList")
        let docId = ref.document().documentID
        let messageDate = firstMessage.sentDate
        guard let dateString = ChatRoomViewController.dateFormatter.string(for: messageDate) else {
            return
        }
        
//        var message = ""
        
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
            "chatRoomId": docId,
            "userId": [senderId, accepterId],
            "isBlock": false,
            "isDelete": false,
            "isTurnOn": true,
            "messagelist": messagelist,
            "latestMessage": [
                "createTime ": dateString,
                "isRead": true,
                "text": message,
                "accepterId": accepterId,
                "senderId": senderId
            ]
        ]
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
    public func getAllChatRoom(id: String, completion: @escaping([ChatRoomList]) -> Void) {
        
        database.collection("ChatRoomList").whereField("userId", arrayContains: id)
        
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
                            print(error)
                        }
                    }
                    
                    completion(chatRoomList)
                }
            }
    }
    
    /// Gets all messages for a given conversation
    public func getAllMessagesForChatRoom(chatRoomId: String, completion: @escaping([Messagelist]) -> Void) {
        
        database.collection("ChatRoomList").document(chatRoomId).collection("Messagelist")
        
            .getDocuments { querySnapshot, error in
                
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var messagelist = [Messagelist]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let message = try document.data(as: Messagelist.self) {
                                
                                messagelist.append(message)
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    completion(messagelist)
                }
            }
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(chatRoomId: String, newMessage: Message) {
        
        let ref = database.collection("ChatRoomList").document("TMTKJhNE2z0u4FyLoDsu").collection("Messagelist")
        
        let docId = ref.document().documentID
        
        let messageDate = newMessage.sentDate
        
        let dateString = ChatRoomViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        switch newMessage.kind {
            
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
        
        let newMessage: [String: Any] = [
            "senderId": "DoIscQXJzIbQfJDTnBVm",
            "accepterId": "GW9pTXyhawNoomsCeoZc",
            "createTime": Timestamp.init(date: Date()),
            "isRead": true,
            "text": message
        ]
        ref.document(docId).setData(newMessage) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(newMessage)")
            }
        }
    }
    
    public func messageListener(chatRoomId: String, completion: @escaping([Messagelist]) -> Void  ) {
        
        database.collection("ChatRoomList").document("TMTKJhNE2z0u4FyLoDsu").collection("Messagelist")
        
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var messagelist = [Messagelist]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let message = try document.data(as: Messagelist.self) {
                                
                                messagelist.append(message)
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    completion(messagelist)
                }
                
            }
        }
}

//            .addSnapshotListener { documentSnapshot, error in
//
//                guard let document = documentSnapshot else {
//
//                    print("Error fetching document: \(error!)")
//
//                    return
//                }
//
//                document.documentChanges.forEach { documentChange in
//
//                    if documentChange.type == .added {
//
//                        var messagelist = [Messagelist]()
//
//                            do {
//
//                                if let message = try documentChange.document.data(as: Messagelist.self) {
//
//                                    messagelist.append(message)
//                                    print(message)
//                                }
//                            } catch {
//                                print(error)
//                            }
//                        }
//
//                    completion(self.messagelist)
//
//                        print("New message: \(documentChange.document.data())")
//                    }
//                }
 
