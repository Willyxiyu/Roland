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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.separatorStyle = .none
        setupTableView()
        tableView.register(NTFNewRequestCell.self, forCellReuseIdentifier: String(describing: NTFNewRequestCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 幫團長拿申請doc
        FirebaseManger.shared.fetchApplyListforHost { result in
            self.applyList = result
            for applyInfo in self.applyList {
                self.applyListRequestSenderId.append(applyInfo.requestSenderId)
                self.applyListEventId.append(applyInfo.eventId)
            }
            
            // 從doc的otherUserid去fetchUserInfo的userid
            self.dispatchGroup.enter()
            FirebaseManger.shared.fetchOtherUserInfo(otherUserId: self.applyListRequestSenderId) { result in
                self.userInfo = result
                self.dispatchGroup.leave()
            }
            
            // 從doc的eventid去fetch GroupEvent的eventid
            self.dispatchGroup.enter()
            FirebaseManger.shared.fetchGroupEventforHost(eventId: self.applyListEventId) { result in
                self.groupEvent = result
                self.dispatchGroup.leave()
            }
            
            self.dispatchGroup.notify(queue: .main) {
                self.tableView.reloadData()
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
        return applyList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(NTFNewRequestCell.self)"), for: indexPath) as? NTFNewRequestCell else {
            fatalError("Error")
        }
        
        guard let photo = userInfo[indexPath.row].photo else {
            fatalError("error")
        }
        
        cell.userImageView.kf.setImage(with: URL(string: photo))
        cell.userNameLabel.text = userInfo[indexPath.row].name
        cell.introLabel.text = "想參加您的\n\(groupEvent[indexPath.row].title)喔！～"
        cell.acceptedButton.addTarget(self, action: #selector(accptedTheRequest), for: .touchUpInside)
        cell.acceptedButton.tag = indexPath.row
        cell.rejectedButton.addTarget(self, action: #selector(rejectTheRequest), for: .touchUpInside)
        cell.rejectedButton.tag = indexPath.row
        selectedEventId = groupEvent[cell.acceptedButton.tag].eventId
        selectedUserId = userInfo[cell.acceptedButton.tag].userId
        
        return cell
    }
    
    @objc func accptedTheRequest() {
        
        guard let selectedEventId = self.selectedEventId else {
            fatalError("error")
        }
        
        guard let selectedUserId = self.selectedUserId else {
            fatalError("error")
        }
    
        FirebaseManger.shared.updateAttendeeId(docId: selectedEventId, attendeeId: selectedUserId)
        
    }
    
    @objc func rejectTheRequest() {
        
    }
}
