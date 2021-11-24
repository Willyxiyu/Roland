//
//  publicCommentViewController.swift
//  
//
//  Created by 林希語 on 2021/11/3.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

class PublicCommentViewController: UIViewController {
    
    let tableView = UITableView()
    
    var eventId = String()
    
    var comment = [Comment]() {
        
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
        self.title = "Public Comment"
        setupTableView()
        tableView.register(GEPCommentCell.self, forCellReuseIdentifier: String(describing: GEPCommentCell.self))
        tableView.register(PublicCommentFooterView.self, forHeaderFooterViewReuseIdentifier: PublicCommentFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        FirebaseManger.shared.blockListListener { userInfo in
            
            self.blockList.removeAll()
            
            if let blockList = userInfo?.blockList {
                
                for blockId in blockList {
                    
                    self.blockList.append(blockId)
                }
            }
            
            FirebaseManger.shared.fetchAllPublicComment(eventId: self.eventId) { results in
                
                self.comment.removeAll()
                
                let filertComment = results.filter { comment -> Bool in
                    !(self.blockList.contains(comment.commentSenderId))
                    
                }
                
                filertComment.forEach { commentSender in
                    
                    FirebaseManger.shared.fetchOtherUserInfo(otherUserId: commentSender.commentSenderId) { [weak self] result in
                        
                        guard let self = self else { return }
                        
                        if let userId = result?.userId {
                            
                            self.userInfos[userId] = result
                        }
                    }
                    
                    self.comment.append(commentSender)
                }
            }
            
            FirebaseManger.shared.fetchUserInfobyUserId { result in
                
                if let result = result {
                    
                    self.selfUserInfo = result
                    
                }
            }
        }
        
        
        
        
        
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
extension PublicCommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPCommentCell.self)"), for: indexPath) as? GEPCommentCell else { fatalError("Error") }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        
        let commentSender = self.comment[indexPath.row]
        
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
        
        self.selectedUserId = self.comment[sender.tag].commentSenderId
        
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
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PublicCommentFooterView.reuseIdentifier) as? PublicCommentFooterView else { fatalError("Error") }
        
        footerView.sendText = { (text) in
            
            FirebaseManger.shared.postPublicComment(eventId: self.eventId, comment: text)
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
