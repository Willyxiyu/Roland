//
//  Firebase+GroupEvent.swift
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
    public func postGroupEventCreatingInfo(groupEventCreatingInfo: GroupEvent, senderId: String) {
        let ref = database.collection("GroupEvent")
        let docId = ref.document().documentID
        
        let groupEventCreatingInfo: [String: Any] = [
            "senderId": senderId,
            "eventId": docId,
            "eventPhoto": groupEventCreatingInfo.eventPhoto,
            "title": groupEventCreatingInfo.title,
            "location": groupEventCreatingInfo.location,
            "maximumOfPeople": groupEventCreatingInfo.maximumOfPeople,
            "info": groupEventCreatingInfo.info,
            "isClose": false,
            "isPending": true,
            "isFull": false,
            "startTime": groupEventCreatingInfo.startTime,
            "endTime": groupEventCreatingInfo.endTime,
            "createTime": Timestamp(date: Date())
            //            "applyList": applyList
        ]
        ref.document(docId).setData(groupEventCreatingInfo) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(groupEventCreatingInfo)")
            }
        }
    }
    
    public func fetchGroupEventCreatingInfo(completion: @escaping ([GroupEvent]) -> Void) {
        //        database.collection("UserInfo").document(userId)
        database.collection("GroupEvent").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(error)
                
                return
                
            } else {
                
                var groupEvent = [GroupEvent]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let groupEventInfo = try document.data(as: GroupEvent.self) {
                            
                            groupEvent.append(groupEventInfo)
                            
                            print(groupEventInfo)
                        }
                        
                    } catch {
                        
                    }
                }
                completion(groupEvent)
            }
        }
    }
    
    public func deleteGroupEventCreatingInfo(docId: String) {
        database.collection("GroupEvent").document(docId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    public func postSenderIdtoApplyList(eventId: String, requestSenderId: String, acceptedId: String ) {
        let ref = database.collection("ApplyList")
        let docId = ref.document().documentID
        let applyList: [String: Any] = [
            "eventId": eventId,
            "requestSenderId": requestSenderId,
            "acceptedId": acceptedId,
            "isAccepted": false,
            "isPending": true,
            "isRejected": false
        ]
        ref.document(docId).setData(applyList) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(applyList)")
            }
        }
    }
    
    public func fetchApplyListforHost(userId: String, completion: @escaping([ApplyList]) -> Void ) {
        database.collection("ApplyList").whereField("acceptedId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var applyList = [ApplyList]()
                    
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    
                    for document in documents {
                        
                        do {
                            
                            if let applyListInfo = try document.data(as: ApplyList.self) {
                                
                                applyList.append(applyListInfo)
                                
                                print(applyListInfo)
                            }
                            
                        } catch {
                            
                        }
                    }
                    completion(applyList)
                }
            }
    }
    
    public func fetchApplyListforOtherUser(eventId: String, requestSenderId: String, completion: @escaping([ApplyList]) -> Void) {
        database.collection("ApplyList").whereField("eventId", isEqualTo: eventId).whereField("requestSenderId", isEqualTo: requestSenderId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var applyList = [ApplyList]()
                    
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    
                    for document in documents {
                        
                        do {
                            
                            if let applyListInfo = try document.data(as: ApplyList.self) {
                                
                                applyList.append(applyListInfo)
                                
                                print(applyListInfo)
                            }
                            
                        } catch {
                            
                        }
                    }
                    completion(applyList)
                }
            }
    }
    
}
