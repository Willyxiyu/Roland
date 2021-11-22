//
//  privateCommentViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/3.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

class PrivateCommentViewController: UIViewController {
    
    let tableView = UITableView()
    
    var eventId = String()
    
    var privateComment = [PrivateComment]() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    var userInfos: [String: UserInfo] = [:] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    var selfUserInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        self.title = "Private Comment"
        setupTableView()
        
        tableView.register(GEPrivateCommentCell.self, forCellReuseIdentifier: String(describing: GEPrivateCommentCell.self))
        tableView.register(PrivateCommentFooterView.self, forHeaderFooterViewReuseIdentifier: PrivateCommentFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        FirebaseManger.shared.fetchAllPrivateComment(eventId: eventId) { results in
            
            self.privateComment.removeAll()
            
            results.forEach { commentSender in
                
                FirebaseManger.shared.fetchOtherUserInfo(otherUserId: commentSender.commentSenderId) { [weak self] result in
                    guard let self = self else { return }
                    
                    if let userId = result?.userId {
                        
                        self.userInfos[userId] = result
                    }
                }
                
                self.privateComment.append(commentSender)
            }
        }
        
        FirebaseManger.shared.fetchUserInfobyUserId { result in
            if let result = result {
                
                self.selfUserInfo = result
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
extension PrivateCommentViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return privateComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPrivateCommentCell.self)"), for: indexPath) as? GEPrivateCommentCell else { fatalError("Error") }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        
        let commentSender = self.privateComment[indexPath.row]
        
        let date = Date(timeIntervalSince1970: commentSender.createTime)
        
        let userId = commentSender.commentSenderId
       
        let userInfo = self.userInfos[userId]
        
        cell.userNameLabel.text = userInfo?.name
        
        cell.messageLabel.text = commentSender.comment
        
        cell.dateLabel.text = dateformatter.string(from: date)
        
        
        if let photo = userInfo?.photo {
            cell.userPhotoImageView.kf.setImage(with: URL(string: photo))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PrivateCommentFooterView.reuseIdentifier) as? PrivateCommentFooterView else { fatalError("Error") }

        footerView.sendText = { (text) in
            
            FirebaseManger.shared.postPrivateComment(eventId: self.eventId, comment: text)
        }
        
        if let photo = selfUserInfo?.photo {
            
            footerView.userPhotoImageView.kf.setImage(with: URL(string: photo))
        }
        
        return footerView
        
        }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

}
