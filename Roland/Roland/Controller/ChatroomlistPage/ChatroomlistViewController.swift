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
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        if !text.isEmpty {
            
//            searching = true
            
            searchUserInfos.removeAll()
            
            otherUserId.removeAll()
            
            for userInfo in userInfos {
                
                if  userInfo.value.name.lowercased().contains(text.lowercased()) {
                    
                    searchUserInfos[userInfo.key] = userInfo.value
                    
                    otherUserId.append(userInfo.key)
                }
                
                searchUserInfosResult = searchUserInfos
            }
            
        } else {
            
//            searching = false
            
            searchUserInfos.removeAll()
            
            otherUserId.removeAll()
            
            userInfos.forEach { (key, value) in
                
                otherUserId.append(key)
            }
            
            searchUserInfos = userInfos
            
            searchUserInfosResult = userInfos
        }
        
        self.chatRoomListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
//        searching = false
//
//        searchChatRoomList.removeAll()
        
        searchUserInfosResult = userInfos
        
        self.chatRoomListTableView.reloadData()
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    let dispatchGroup = DispatchGroup()
    
    private var chatRoomList = [ChatRoomList]() {
        
        didSet {
            
            self.otherUserId.removeAll()
            
            self.searchUserInfosResult.removeAll()
            
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            for chatRoom in chatRoomList {
                
                for otherUserId in chatRoom.userId {
                    
                    if otherUserId != userId {
                        
                        self.otherUserId.append(otherUserId)
                        
                        FirebaseManger.shared.fetchOtherUserInfo(otherUserId: otherUserId) { [weak self] result in
                            
                            guard let self = self else { return }
                            
                            self.userInfos[otherUserId] = result
                        }
                    }
                }
            }
        }
    }
    
    var searchUserInfosResult: [String: UserInfo] = [:] {
        
        didSet {
            
            chatRoomListTableView.reloadData()
        }
    }
    
    var userInfos: [String: UserInfo] = [:] {
        
        didSet {
            
            searchUserInfosResult = userInfos
            
        }
    }
    
    var searchUserInfos: [String: UserInfo] = [:]
    
    var otherUserId = [String]()
    
    private var searchChatRoomList = [ChatRoomList]()
    
    var searching = false
    
    private let searchController = UISearchController()
    
    var chatRoomOtherUserId = [String]()
    
    override func viewDidLoad() {
        
        setupChatRoomListTableView()
        chatRoomListTableView.separatorStyle = .none
        self.hideKeyboardWhenTappedAround()
        self.title = "Message"
        configureSearchController()
        
        FirebaseManger.shared.chatRoomListListener { results in
            
            self.chatRoomList.removeAll()
            
            results.forEach { result in
                
                self.chatRoomList.append(result)
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
}

extension ChatroomlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            
            return self.searchUserInfos.count
            
        } else {
            
            return self.searchUserInfosResult.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = chatRoomListTableView.dequeueReusableCell(withIdentifier: String(describing: "\(ChatroomListTableViewCell.self)"),
                                                                   for: indexPath) as? ChatroomListTableViewCell else { fatalError("No cell") }
        
        // normal mode
        
        let otherUserId = self.otherUserId[indexPath.row]
        
        let userInfo = self.searchUserInfosResult[otherUserId]
        
        cell.userNameLabel.text = userInfo?.name
        
        cell.userMessageLabel.text = self.chatRoomList[indexPath.row].latestMessage.text
        
        if let photo = userInfo?.photo {
            
            cell.userImageView.kf.setImage(with: URL(string: photo))
            
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
        
        //        if editingStyle == .delete {
        //
        //            tableView.beginUpdates()
        //
        //            guard let userId = userInfo[indexPath.row].userId else {
        //                return
        //            }
        //            FirebaseManger.shared.removeAccepterIdFromSelflikeList(accepterId: userId)
        //
        //            FirebaseManger.shared.postAccepterIdtoSelfDislikeList(accepterId: userId)
        //
        //            userInfo.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //
        //            tableView.endUpdates()
        //
        //        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "封鎖"
    }
}
