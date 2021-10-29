//
//  Firebase+UserInfo.swift
//  Roland
//
//  Created by 林希語 on 2021/10/29.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension FirebaseManger {
    
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
                            print(userInfo)
                        }
                        
                    } catch {
                        
                    }
                }
                
                completion(users)
            }
        }
    }
}
