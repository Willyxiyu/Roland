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
    public func postGroupEventCreatingInfo(groupEventCreatingInfo: GroupEvent) {
        let ref = database.collection("GroupEvent")
        let docId = ref.document().documentID
        
        let groupEventCreatingInfo: [String: Any] = [
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
            "createTime": Timestamp(date: Date()),
            "applyList": applyList
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
}
