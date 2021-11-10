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
import FirebaseAuth

extension FirebaseManger {
    
    func postNewUserInfo(name: String, gender: String, age: String, photo: String, email: String) {
        let ref = database.collection("UserInfo")
        guard let docId = Auth.auth().currentUser?.uid else { return }
        let userInfo: [String: Any] = [
            "name": name,
            "gender": gender,
            "age": age,
            "photo": photo,
            "email": email,
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
    
    func fetchUserInfobyEmail(email: String, completion: @escaping ([UserInfo]) -> Void ) {
        database.collection("UserInfo").whereField("email", isEqualTo: email)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var userInfo = [UserInfo]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let user = try document.data(as: UserInfo.self) {
                                
                                userInfo.append(user)
                                
                                print(user)
                            }
                            
                        } catch {
                            
                        }
                    }
                    
                    completion(userInfo)
                }
            }
    }
    
    func updateUserInfo(name: String, email: String, age: String, gender: String, photo: String, docId: String) {
        let ref = database.collection("UserInfo").document(docId)
//        guard let docId = Auth.auth().currentUser?.uid else { return }
        ref.updateData([
            "name": name,
            "gender": gender,
            "age": age,
            "photo": photo,
            "email": email
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func postEventIdtoMeEventIdArray(docId: String, eventId: String) {
        let ref = database.collection("UserInfo").document(docId)
        ref.updateData(["myEventId": FieldValue.arrayUnion([eventId])])
    }
    
    func getUserInfoFromFirestore(completion: @escaping ([UserInfo]) -> Void) {
        database.collection("UserInfo").getDocuments { (querySnapshot, error) in
            if let error = error {
                
                print(error)
                
                return
                
            } else {
                
                var userInfo = [UserInfo]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let user = try document.data(as: UserInfo.self) {
                            
                            userInfo.append(user)
                            print(user)
                        }
                        
                    } catch {
                        
                    }
                }
                
                completion(userInfo)
            }
        }
    }
    
    func fetchUserInfobtFilterResult(gender: String, minAge: String, maxAge: String, completion: @escaping ([UserInfo]) -> Void ) {
        
        if  gender == "全部" {
            
            database.collection("UserInfo").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        
                        print(error)
                        
                        return
                        
                    } else {
                        
                        var userInfo = [UserInfo]()
                        
                        for document in querySnapshot!.documents {
                            
                            do {
                                
                                if let user = try document.data(as: UserInfo.self) {
                                    
                                    userInfo.append(user)
                                    print(user)
                                }
                                
                            } catch {
                                
                            }
                        }
                        
                        completion(userInfo)
                    }
                }
            
        } else {
            
            database.collection("UserInfo").whereField("gender", isEqualTo: gender).whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        
                        print(error)
                        
                        return
                        
                    } else {
                        
                        var userInfo = [UserInfo]()
                        
                        for document in querySnapshot!.documents {
                            
                            do {
                                
                                if let user = try document.data(as: UserInfo.self) {
                                    
                                    userInfo.append(user)
                                    
                                    print(user)
                                }
                                
                            } catch {
                                
                            }
                        }
                        
                        completion(userInfo)
                    }
                }
        }
    
}
}
