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
    var users = [UserInfo]()
    lazy var database = Firestore.firestore()
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
                            print(users)
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
    public func createNewChatRoom(with otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
    }
    /// Fetches and returns all conversation for the users with passed in email
    public func getAllChatRoom(for email: String, completion: @escaping(Result<String, Error>) -> Void) {
    }
    
    /// Gets all messages for a given conversation
    public func getAllMessagesForChatRoom(with id: String, completion: @escaping(Result<String, Error>) -> Void) {
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
}
