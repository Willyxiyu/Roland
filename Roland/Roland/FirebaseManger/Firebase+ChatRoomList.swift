//
//  Firebase+ChatRoomList.swift
//  Roland
//
//  Created by 林希語 on 2021/10/29.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MessageKit
import FirebaseAuth

extension FirebaseManger {
    
    /// Creates a new conversation with target userId and first message sent
    public func createNewChatRoom(accepterId: String, firstMessage: Message) {
        
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        
        let ref = database.collection("ChatRoomList")
        let docId = ref.document().documentID
        let messageDate = firstMessage.sentDate
        
        guard let dateString = ChatRoomViewController.dateFormatter.string(for: messageDate) else {
            return
        }
        
        var message = ""
        
        switch firstMessage.kind {
            
        case .text(let messageText):
            message = messageText
            
        case .attributedText:
            break
        case .photo:
            break
        case .video:
            break
        case .location:
            break
        case .emoji:
            break
        case .audio:
            break
        case .contact:
            break
        case .linkPreview:
            break
        case .custom:
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
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        database.collection("ChatRoomList").whereField("userId", arrayContains: userId)
        
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
    
    /// Sends a message with target conversation and message
    public func sendMessage(chatRoomId: String, accepterId: String, newMessage: Message) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("ChatRoomList").document(chatRoomId).collection("Messagelist")
        
        let docId = ref.document().documentID
        
        //        let messageDate = newMessage.sentDate
        
        //        let dateString = ChatRoomViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        var photoMessage = ""
        
        switch newMessage.kind {
            
        case .text(let messageText):
            message = messageText
        case .attributedText:
            break
        case .photo(let mediaItem):
            if let targetUrlString = mediaItem.url?.absoluteString {
                photoMessage = targetUrlString
            }
        case .video:
            break
        case .location:
            break
        case .emoji:
            break
        case .audio:
            break
        case .contact:
            break
        case .linkPreview:
            break
        case .custom:
            break
        }
        
        let newMessage: [String: Any] = [
            "senderId": userId,
            "accepterId": accepterId,
            "createTime": Timestamp.init(date: Date()),
            "isRead": false,
            "text": message,
            "photoMessage": photoMessage
        ]
        ref.document(docId).setData(newMessage) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(newMessage)")
            }
        }
    }
    
    public func updateLastestMessage(docId: String, message: String, accepterId: String) {
        
        let ref = database.collection("ChatRoomList").document(docId)
        guard let userId = Auth.auth().currentUser?.uid else { return }

        ref.updateData([
            "latestMessage": [
                "createTime ": NSDate().timeIntervalSince1970,
                "isRead": true,
                "text": message,
                "accepterId": accepterId,
                "senderId": userId
            ]
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    public func messageListener(chatRoomId: String, completion: @escaping([Messagelist]) -> Void  ) {
        
        database.collection("ChatRoomList").document(chatRoomId).collection("Messagelist").order(by: "createTime")
        
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
    
    public func chatRoomListListener(completion: @escaping([ChatRoomList]) -> Void ) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        database.collection("ChatRoomList").whereField("userId", arrayContains: userId).addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                
                print(error)
                
                return
                
            } else {
                
                var chatRoomList = [ChatRoomList]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let chatRoom = try document.data(as: ChatRoomList.self) {
                            
                            chatRoomList.append(chatRoom)
                        }
                    } catch {
                        print(error)
                    }
                }
                
                completion(chatRoomList)
            }
        }
    }
    
    public func deleteChatroomForBlocking(documentId: String) {
        database.collection("ChatRoomList").document(documentId).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}
