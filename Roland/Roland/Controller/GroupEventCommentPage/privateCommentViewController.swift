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
    
    var selectedUserId: String?
    
    var blockList = [String]()
    
    
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
        
        FirebaseManger.shared.blockListListener { userInfo in
            
            self.blockList.removeAll()
            
            if let blockList = userInfo?.blockList {
                
                for blockId in blockList {
                    
                    self.blockList.append(blockId)
                }
            }
            
            FirebaseManger.shared.fetchAllPrivateComment(eventId: self.eventId) { results in
                
                self.privateComment.removeAll()
                
                let filertComment = results.filter { privateComment -> Bool in
                    !(self.blockList.contains(privateComment.commentSenderId))
                    
                }
        
                filertComment.forEach { commentSender in
                    
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
        
        cell.ellipsisButton.addTarget(self, action: #selector(ellipsis(sender:)), for: .touchUpInside)
        cell.ellipsisButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func ellipsis(sender: UIButton) {
        
        self.selectedUserId = self.privateComment[sender.tag].commentSenderId
        
        let alert = UIAlertController(title: "檢舉", message: "您的檢舉將會匿名，如果有人有立即的人身安全疑慮，請立即與當地緊急救護服務連絡，把握救援時間！檢舉內容：仇恨言論、符號、垃圾訊息、霸凌或騷擾、自殺或自殘、誤導或詐騙....等等", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let confirm = UIAlertAction(title: "確認檢舉", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            
            guard let userId = self.selectedUserId else {
                return
            }
            
            FirebaseManger.shared.postGroupEventIdtoSelfBlockList(blockId: userId)
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
        
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
