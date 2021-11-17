//
//  NotificationViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/2.
//

import Foundation
import UIKit
import Kingfisher
import FBLPromises

class NotificationViewController: UIViewController {
    
    let tableView = UITableView()
    let dispatchGroup = DispatchGroup()
    var applyList = [ApplyList]()
    var userInfo = [UserInfo]() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    var groupEvent = [GroupEvent]()
    var applyListRequestSenderId = [String]()
    var applyListEventId = [String]()
    let nTFNewRequestCell = NTFNewRequestCell()
    var selectedEventId: String?
    var selectedUserId: String?
    var selectedDocumentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Notification"
        tableView.separatorStyle = .none
        setupTableView()
        tableView.register(NTFNewRequestCell.self, forCellReuseIdentifier: String(describing: NTFNewRequestCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.applyListRequestSenderId.removeAll()
        self.applyListEventId.removeAll()
        
        // 幫團長拿申請doc
        FirebaseManger.shared.fetchApplyListforHost { result in
            
            if result.isEmpty {
                
                self.tableView.isHidden = true
                
                self.view.backgroundColor = .white
                
            } else {
                
                self.tableView.isHidden = false
                
                self.applyList = result
                for applyInfo in self.applyList {
                    self.applyListRequestSenderId.append(applyInfo.requestSenderId)
                    self.applyListEventId.append(applyInfo.eventId)
                }
                
                // 從doc的otherUserid去fetchUserInfo的userid
                self.userInfo.removeAll()
                for otherUserId in self.applyListRequestSenderId {
                    FirebaseManger.shared.fetchOtherUserInfo(otherUserId: otherUserId) { result in
                        guard let result = result else { fatalError("error") }
                        self.userInfo.append(result)
                    }
                }
                // 從doc的eventid去fetch GroupEvent的eventid
                self.groupEvent.removeAll()
                for groupEventId in self.applyListEventId {
                    FirebaseManger.shared.fetchGroupEventforHost(eventId: groupEventId) { result in
                        guard let result = result else { fatalError("error") }
                        self.groupEvent.append(result)
                    }
                }
            }
        }
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // one is new applyrequest
        // one is new message from groupevent
        return userInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(NTFNewRequestCell.self)"), for: indexPath) as? NTFNewRequestCell else {
            fatalError("Error")
        }
        
        if let photo = self.userInfo[indexPath.row].photo {
            
            cell.userImageView.kf.setImage(with: URL(string: photo))
            
        }
        cell.userNameLabel.text = self.userInfo[indexPath.row].name
        
        cell.introLabel.text = "想參加您的\n\(self.groupEvent[indexPath.row].title)喔！～"
        
        cell.acceptedButton.addTarget(self, action: #selector(self.accptedTheRequest), for: .touchUpInside)
        cell.acceptedButton.tag = indexPath.row
        cell.rejectedButton.addTarget(self, action: #selector(self.rejectTheRequest), for: .touchUpInside)
        cell.rejectedButton.tag = indexPath.row
        
        self.selectedEventId = self.groupEvent[cell.acceptedButton.tag].eventId
        self.selectedUserId = self.userInfo[cell.acceptedButton.tag].userId
        self.selectedDocumentId = self.applyList[cell.acceptedButton.tag].documentId
        
        self.selectedEventId = self.groupEvent[cell.rejectedButton.tag].eventId
        self.selectedUserId = self.userInfo[cell.rejectedButton.tag].userId
        self.selectedDocumentId = self.applyList[cell.rejectedButton.tag].documentId
        
        return cell
    }
    
    @objc func accptedTheRequest() {
        
        guard let selectedEventId = self.selectedEventId else {
            fatalError("error")
        }
        
        guard let selectedUserId = self.selectedUserId else {
            fatalError("error")
        }
        
        guard let selectedDocumentId = self.selectedDocumentId else {
            fatalError("error")
        }
        
        FirebaseManger.shared.updateAttendeeId(docId: selectedEventId, attendeeId: selectedUserId)
        
        FirebaseManger.shared.deleteUserIdFromApplyList(documentId: selectedDocumentId)
        
        tableView.reloadData()
        
    }
    
    @objc func rejectTheRequest() {
        
        guard let selectedDocumentId = self.selectedDocumentId else { fatalError("error") }
        
        FirebaseManger.shared.deleteUserIdFromApplyList(documentId: selectedDocumentId)

        tableView.reloadData()
        
    }
}
