//
//  ChatroomlistViewController.swift
//  
//
//  Created by 林希語 on 2021/10/22.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import Kingfisher

// class ChatroomlistViewController: UIViewController {
class ChatroomlistViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var chatRoomList = [ChatRoomList]() {
        
        didSet {
            
            chatRoomListTableView.reloadData()
        }
        
    }
    
    var searchChatRoomList  = [ChatRoomList]()
    
    var searchUserInfosResult: [String: UserInfo] = [:]
    
    var userInfos: [String: UserInfo] = [:]
    
    var searchUserInfos: [String: UserInfo] = [:]
    
    var searching = false
    
    private let searchController = UISearchController()
    
    var chatRoomOtherUserId = [String]()
    
    var isDeleting = false
    
    override func viewDidLoad() {
        
        setupChatRoomListTableView()
        
        chatRoomListTableView.separatorStyle = .none
        
        self.hideKeyboardWhenTappedAround()
        
        self.title = "Message"
        
        configureSearchController()
        
        FirebaseManger.shared.chatRoomListListener { results in
            
            self.chatRoomList.removeAll()
            
            results.forEach { chatRoom in
                
                FirebaseManger.shared.fetchOtherUserInfo(otherUserId: chatRoom.otherUserID) { [weak self] result in
                    
                    guard let self = self else { return }
                    
                    if let userId = result?.userId {
                        
                        self.userInfos[userId] = result
                    }
                    
                    self.chatRoomList.append(chatRoom)
                    
                    self.searchChatRoomList.append(chatRoom)
                    
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    private lazy var chatRoomListTableView: UITableView = {
        let chatRoomListTableView = UITableView()
        return chatRoomListTableView
    }()
    
    private func setupChatRoomListTableView() {
        chatRoomListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chatRoomListTableView)
        chatRoomListTableView.register(ChatroomListTableViewCell.self, forCellReuseIdentifier: String(describing: ChatroomListTableViewCell.self))
        chatRoomListTableView.dataSource = self
        chatRoomListTableView.delegate = self
        
        NSLayoutConstraint.activate([
            chatRoomListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            chatRoomListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatRoomListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatRoomListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search a chatroom!"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        if !text.isEmpty {
            
            searching = true
            
            searchUserInfos.removeAll()
            
            for userInfo in userInfos {
                
                if  userInfo.value.name.lowercased().contains(text.lowercased()) {
                    
                    searchUserInfos[userInfo.key] = userInfo.value
                    
                    searchChatRoomList = searchChatRoomList.filter { $0.otherUserID == userInfo.key }
                    
                }
            }
            
        } else {
            
            searching = false
            
            searchUserInfos = userInfos
            
            searchChatRoomList = chatRoomList
            
        }
        
        self.chatRoomListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        
        searchChatRoomList = chatRoomList
        
        self.chatRoomListTableView.reloadData()
    }
    
}

extension ChatroomlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            
            return self.searchChatRoomList.count
            
        } else {
            
            return self.chatRoomList.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = chatRoomListTableView.dequeueReusableCell(withIdentifier: String(describing: "\(ChatroomListTableViewCell.self)"),
                                                                   for: indexPath) as? ChatroomListTableViewCell else { fatalError("No cell") }
        if searching {
            
            let chatRoom = self.searchChatRoomList[indexPath.row]
            
            let otherUserId = chatRoom.otherUserID
            
            let userInfo = self.userInfos[otherUserId]
            
            cell.userNameLabel.text = userInfo?.name
            
            cell.userMessageLabel.text = chatRoom.latestMessage.text
            
            if let photo = userInfo?.photo {
                
                cell.userImageView.kf.setImage(with: URL(string: photo))
                
            }
            
        } else {
            
            let chatRoom = self.chatRoomList[indexPath.row]
            
            let otherUserId = chatRoom.otherUserID
            
            let userInfo = self.userInfos[otherUserId]
            
            cell.userNameLabel.text = userInfo?.name
            
            cell.userMessageLabel.text = chatRoom.latestMessage.text
            
            if let photo = userInfo?.photo {
                
                cell.userImageView.kf.setImage(with: URL(string: photo))
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatRoomListTableView.deselectRow(at: indexPath, animated: true)
        
        let chatRoomViewController = ChatRoomViewController()
        
        chatRoomViewController.selectedChatroomId = chatRoomList[indexPath.row].chatRoomId
        
        chatRoomViewController.userInChatRoom = chatRoomList[indexPath.row].userId
        
        chatRoomViewController.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            
            isDeleting = true
            
            let otherUserId = self.chatRoomList[indexPath.row].otherUserID
            
            searchUserInfosResult.removeValue(forKey: otherUserId)
            
            guard let chatRoomId = chatRoomList[indexPath.row].chatRoomId else {
                return
            }
            
            FirebaseManger.shared.deleteChatroomForBlocking(documentId: chatRoomId)
            
            self.chatRoomList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "封鎖"
    }
}
