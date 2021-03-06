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
import FirebaseAuth

extension FirebaseManger {
    public func postGroupEventCreatingInfo(groupEventCreatingInfo: GroupEvent) {
        let ref = database.collection("GroupEvent")
        let docId = ref.document().documentID
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let groupEventCreatingInfo: [String: Any] = [
            "senderId": userId,
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
            "attendee": [],
            "createTime": Timestamp(date: Date())
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
    
    public func fetchGroupEventforHost(eventId: String, completion: @escaping (GroupEvent?) -> Void) {
        database.collection("GroupEvent").whereField("eventId", isEqualTo: eventId).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(error)
                
                return
                
            } else {
                
                var groupEvent: GroupEvent?
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let groupEventInfo = try document.data(as: GroupEvent.self) {
                            
                            groupEvent = groupEventInfo
                            
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
    
    public func postSenderIdtoApplyList(eventId: String, acceptedId: String ) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("ApplyList")
        let docId = ref.document().documentID
        let applyList: [String: Any] = [
            "eventId": eventId,
            "requestSenderId": userId,
            "acceptedId": acceptedId,
            "documentId": docId
        ]
        ref.document(docId).setData(applyList) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(applyList)")
            }
        }
    }
    
    public func fetchApplyListforHost(completion: @escaping([ApplyList]) -> Void ) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
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
    
    public func fetchApplyListforOtherUser(eventId: String, completion: @escaping([ApplyList]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        database.collection("ApplyList").whereField("eventId", isEqualTo: eventId).whereField("requestSenderId", isEqualTo: userId)
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
    
    public func postPublicComment(eventId: String, comment: String) {
        let ref = database.collection("GroupEvent").document(eventId).collection("Comment")
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let docId = ref.document().documentID
        
        let newComment: [String: Any] = [
            "commentSenderId": userId,
            "comment": comment,
            "createTime": NSDate().timeIntervalSince1970
        ]
        ref.document(docId).setData(newComment) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(newComment)")
            }
        }
    }
    
    public func fetchAllPublicComment(eventId: String, completion: @escaping([Comment]) -> Void) {
        
        database.collection("GroupEvent").document(eventId).collection("Comment")
        
            .order(by: "createTime")
        
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var comment = [Comment]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let newComment = try document.data(as: Comment.self) {
                                
                                comment.append(newComment)
                            }
                            
                        } catch {
                            
                            print(error)
                        }
                    }
                    
                    completion(comment)
                }
            }
    }
    
    public func postPrivateComment(eventId: String, comment: String) {
        
        let ref = database.collection("GroupEvent").document(eventId).collection("PrivateComment")
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let docId = ref.document().documentID
        
        let newComment: [String: Any] = [
            
            "commentSenderId": userId,
            "comment": comment,
            "createTime": NSDate().timeIntervalSince1970
        ]
        ref.document(docId).setData(newComment) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document data: \(newComment)")
            }
        }
    }
    
    public func fetchAllPrivateComment(eventId: String, completion: @escaping([PrivateComment]) -> Void) {
        
        database.collection("GroupEvent").document(eventId).collection("PrivateComment")
        
            .order(by: "createTime")
        
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var privateComment = [PrivateComment]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            
                            if let newComment = try document.data(as: PrivateComment.self) {
                                
                                privateComment.append(newComment)
                            }
                            
                        } catch {
                            
                            print(error)
                        }
                    }
                    
                    completion(privateComment)
                }
            }
    }
    // reedit the group event form the reedit page after done edit back to detail page should fetch the info and update.
    // swiftlint:disable function_parameter_count
    public func updateGroupEventInfo(docId: String, eventPhoto: String, title: String, maximumOfPeople: Int, startTime: String, endTime: String, location: String, info: String, attendee: [String] ) {
        let ref = database.collection("GroupEvent").document(docId)
        ref.updateData([
            "eventPhoto": eventPhoto,
            "title": title,
            "maximumOfPeople": maximumOfPeople,
            "startTime": startTime,
            "endTime": endTime,
            "location": location,
            "attendee": attendee,
            "info": info
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    public func fetchUpdateGEventInfoFromReEditPage(docId: String, completion: @escaping(GroupEvent) -> Void) {
        
        let ref = database.collection("GroupEvent").document(docId)
        
        ref.getDocument { (document, error) in
            
            let result = Result {
                
                try document?.data(as: GroupEvent.self)
            }
            switch result {
            case .success(let groupEvent):
                
                if let groupEvent = groupEvent {
                    
                    completion(groupEvent)
                    
                    print("GroupEvent: \(groupEvent)")
                } else {
                    
                    print("Document does not exist")
                }
            case .failure(let error):
                
                print("Error decoding groupEvent: \(error)")
            }
        }
    }
    
    // MARK: - NotiPage
    
    public func updateAttendeeId(docId: String, attendeeId: String) {
        let ref = database.collection("GroupEvent").document(docId)
        ref.updateData(["attendee": FieldValue.arrayUnion([attendeeId])]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    public func deleteAttendeeIdForQuitEvent(docId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("GroupEvent").document(docId)
        ref.updateData(["attendee": FieldValue.arrayRemove([userId])]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    public func deleteUserIdFromApplyList(documentId: String) {
        database.collection("ApplyList").document(documentId).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    public func fetchApplyListforCancelRegister(eventId: String, completion: @escaping(ApplyList?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        database.collection("ApplyList").whereField("eventId", isEqualTo: eventId).whereField("requestSenderId", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    
                    print(error)
                    
                    return
                    
                } else {
                    
                    var applyList: ApplyList?
                    
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    
                    for document in documents {
                        
                        do {
                            
                            if let applyListInfo = try document.data(as: ApplyList.self) {
                                
                                applyList = applyListInfo
                                
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
