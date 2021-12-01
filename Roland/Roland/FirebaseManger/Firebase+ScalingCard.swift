//
//  Firebase+ScalingCard.swift
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
    
    //  抓自己的userInfo裡的dislikelist & likelist的 userId用foreach 裝到[ ] = userId，排除後，留下的就是可以滑卡的數量
    func fetchUserListForScalingCard(completion: @escaping ([UserInfo]) -> Void) {
        guard let ownUserId = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("UserInfo").whereField("userId", isNotEqualTo: ownUserId)
        ref.getDocuments {  (querySnapshot, error) in
            
            if let error = error {
                
                print(error)
                
                return
                
            } else {
                
                var userInfoOfScalingCard = [UserInfo]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let user = try document.data(as: UserInfo.self) {
                            
                            userInfoOfScalingCard.append(user)
                        }
                        
                    } catch {
                        
                    }
                }
                
                completion(userInfoOfScalingCard)
            }
        }
        
    }
    
    // 將對方的ID加入到自己的likelist
    func postAccepterIdtoSelflikeList(accepterId: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = database.collection("UserInfo").document(userId)
        
        ref.updateData(["likeList": FieldValue.arrayUnion([accepterId])]) { error in
            
            if let error = error {
                
                print("Error writing document: \(error)")
                
            } else {
                
                print("Document data: \("likeList")")
            }
        }
        
    }
    
    // 將對方的ID移除自己的likelist
    func removeAccepterIdFromSelflikeList(accepterId: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = database.collection("UserInfo").document(userId)
        
        ref.updateData(["likeList": FieldValue.arrayRemove([accepterId])]) { error in
            
            if let error = error {
                
                print("Error writing document: \(error)")
                
            } else {
                
                print("Document data: \("likeList")")
            }
        }
        
    }
    
    // 將對方的ID加入到自己的dislikeList
    func postAccepterIdtoSelfDislikeList(accepterId: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = database.collection("UserInfo").document(userId)
        
        ref.updateData(["dislikeList": FieldValue.arrayUnion([accepterId])]) { error in
            
            if let error = error {
                
                print("Error writing document: \(error)")
                
            } else {
                
                print("Document data: \("dislikeList")")
            }
        }
        
    }
    
    // 當滑喜歡時，在對方的likelist，找自己的id，若有自己的id，代表對方有滑喜歡，此時建立聊天室，若對方表列無自己的id，則加對方的id到自己的likeList裡(postAccepterIdtoSelflikeList)。
    func fetchlikeListOfUserId(accepterId: String, completion: @escaping ([UserInfo]) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = database.collection("UserInfo").whereField("userId", isEqualTo: accepterId).whereField("likeList", arrayContainsAny: [userId])
        
        ref.getDocuments {  (querySnapshot, error) in
            
            if let error = error {
                
                print(error)
                
                return
                
            } else {
                
                var userInfoOflikeList = [UserInfo]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let user = try document.data(as: UserInfo.self) {
                            
                            userInfoOflikeList.append(user)
                            
                            print(user)
                        }
                        
                    } catch {
                        
                    }
                }
                
                completion(userInfoOflikeList)
            }
        }
    }
}
