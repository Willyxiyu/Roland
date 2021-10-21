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
    func getUserInfo(completion: @escaping (Result<[UserInfo], Error>) -> Void) { // only needs name, birth
        database.collection("UserInfo").whereField("gender", isEqualTo: "遊戲Boy").getDocuments { (querySnapshot, error) in
            if let error = error {
//                print(error)
                completion(.failure(error))
            } else {
                var userInfoArray = [UserInfo]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let userInfo = try document.data(as: UserInfo.self) {
                            userInfoArray.append(userInfo)
//                            print(userInfo)
                            print(userInfoArray)
                        }

                    } catch {
                    }
                }
            }
        }
    }
}
