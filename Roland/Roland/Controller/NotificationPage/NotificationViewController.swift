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
    var userInfo = [UserInfo]()
    var groupEvent = [GroupEvent]()
    var applyListRequestSenderId = [String]()
    var applyListEventId = [String]()
    let nTFNewRequestCell = NTFNewRequestCell()
    var selectedEventId: String?
    var selectedUserId: String?
    var selectedDocumentId: String?
    var noNotiImageView = UIImageView(image: UIImage(named: "尚無通知"))
    
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
        setupNoNotiImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        // 幫團長拿申請doc
        
        FirebaseManger.shared.fetchApplyListforHost { result in
            
            self.applyList.removeAll()
            self.applyListRequestSenderId.removeAll()
            self.applyListEventId.removeAll()
            self.userInfo.removeAll()
            self.groupEvent.removeAll()
            self.applyList = result
                                
            let queA = DispatchQueue(label: "Serial")
            queA.async {
                
                let simphore = DispatchSemaphore(value: 0)
                
                for applyInfo in self.applyList {
                    self.applyListRequestSenderId.append(applyInfo.requestSenderId)
                    self.applyListEventId.append(applyInfo.eventId)
                }
                
                // 從doc的otherUserid去fetchUserInfo的userid
            
                for otherUserId in self.applyListRequestSenderId {
                    self.dispatchGroup.enter()
                    FirebaseManger.shared.fetchOtherUserInfo(otherUserId: otherUserId) { result in
                        guard let result = result else { simphore.signal()
                            fatalError("error")
                           }
                        self.userInfo.append(result)
                        self.notiPageIsEmpty()
                        self.dispatchGroup.leave()
                        simphore.signal()
                    }
                    simphore.wait()
                }
                
                // 從doc的eventid去fetch GroupEvent的eventid
                for groupEventId in self.applyListEventId {
                    self.dispatchGroup.enter()
                    FirebaseManger.shared.fetchGroupEventforHost(eventId: groupEventId) { result in
                        guard let result = result else {
                            fatalError("error")
                            simphore.signal()
                        }
                        self.groupEvent.append(result)
                        self.dispatchGroup.leave()
                        simphore.signal()
                    }
                    simphore.wait()
                }
                self.dispatchGroup.notify(queue: .main) {
                    self.tableView.reloadData()
                }
                
            }
            
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
    
    private func setupNoNotiImageView() {
        noNotiImageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(noNotiImageView)
        NSLayoutConstraint.activate([
            noNotiImageView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noNotiImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noNotiImageView.heightAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.5),
            noNotiImageView.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.5)
            
        ])
    }
    
    func notiPageIsEmpty() {
        
        if userInfo.count == 0 {
            
            noNotiImageView.isHidden = false
            
        } else {
            
            noNotiImageView.isHidden = true
        }
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
        
        let user = self.userInfo[indexPath.row]
        
        if let photo = user.photo {
            
            cell.userImageView.kf.setImage(with: URL(string: photo))
            
        }
        cell.userNameLabel.text = user.name
        
        cell.introLabel.text = "想參加您的\n\(self.groupEvent[indexPath.row].title)喔！～"
        
        cell.acceptedButton.addTarget(self, action: #selector(accptedTheRequest(sender:)), for: .touchUpInside)
        cell.acceptedButton.tag = indexPath.row
        
        cell.rejectedButton.addTarget(self, action: #selector(rejectTheRequest(sender:)), for: .touchUpInside)
        cell.rejectedButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func accptedTheRequest(sender: UIButton) {
        
        self.selectedEventId = self.groupEvent[sender.tag].eventId
        
        self.selectedUserId = self.userInfo[sender.tag].userId
        
        self.selectedDocumentId = self.applyList[sender.tag].documentId
        
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
        
        self.tableView.reloadData()
        
    }
    
    @objc func rejectTheRequest(sender: UIButton) {
        
        self.selectedEventId = self.groupEvent[sender.tag].eventId
        
        self.selectedUserId = self.userInfo[sender.tag].userId
        
        self.selectedDocumentId = self.applyList[sender.tag].documentId
        
        guard let selectedDocumentId = self.selectedDocumentId else { fatalError("error") }
        
        FirebaseManger.shared.deleteUserIdFromApplyList(documentId: selectedDocumentId)
        
        self.tableView.reloadData()
        
    }
}
