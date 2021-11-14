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

class ChatroomlistViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            searching = true
            searchUserInfo.removeAll()
            for user in userInfo {
                if user.name.lowercased().contains(text.lowercased()) {
                    searchUserInfo.append(user)
                }
                
            }
        } else {
            searching = false
            searchUserInfo.removeAll()
            searchUserInfo = userInfo
        }
        
        self.chatRoomListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchChatRoomList.removeAll()
        self.chatRoomListTableView.reloadData()
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var chatRoomList = [ChatRoomList]()
    
    private var searchChatRoomList = [ChatRoomList]()
    
    var searchUserInfo = [UserInfo]()
    
    var userInfo = [UserInfo]() {
        
        didSet {
            
            self.chatRoomListTableView.reloadData()
        }
    }
    
    var searching = false
    
    private let searchController = UISearchController()
    var chatRoomOtherUserId = [String]()
    
    override func viewDidLoad() {
        setupChatRoomListTableView()
        setupNoConversationLabel()
        chatRoomListTableView.separatorStyle = .none
        self.hideKeyboardWhenTappedAround()
        self.title = "Message"
        configureSearchController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseManger.shared.getAllChatRoom { list in
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            self.chatRoomList = list
            
            for chatRoom in self.chatRoomList {
                for otherUserId in chatRoom.userId {
                    if otherUserId != userId {
                        self.chatRoomOtherUserId.append(otherUserId)
                    }
                }
            }
            
            FirebaseManger.shared.fetchOtherUserInfo(otherUserId: self.chatRoomOtherUserId) { result in
                self.userInfo = result
            }
            
            self.chatRoomListTableView.reloadData()
        }
    }
    
    @objc private func didTapComposeButton() {
        let newConversationViewController = NewConversationViewController()
        newConversationViewController.completion = { [weak self] result in
            print("\(result)")
            self?.createNewConversation(result: result)
        }
        
        let navVC = UINavigationController(rootViewController: newConversationViewController)
        present(navVC, animated: true)
    }
    private func createNewConversation(result: [String: String]) {
        
        guard let name = result["name"] else { return }
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.isNewConversation = true
        chatRoomViewController.title = name
        chatRoomViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    private lazy var chatRoomListTableView: UITableView = {
        let chatRoomListTableView = UITableView()
        //        chatRoomListTableView.isHidden = true
        // once the user doesn't has any conversation do not show the tableview instead, shows the label say 'no conversation'
        return chatRoomListTableView
    }()
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "搜尋"
        searchTextField.backgroundColor = UIColor.secondThemeColor
        searchTextField.returnKeyType = .done
        searchTextField.setLeftPaddingPoints(10)
        return searchTextField
    }()
    private lazy var noConversationLabel: UILabel = {
        let noConversationLabel = UILabel()
        noConversationLabel.text = "No Conversation!"
        noConversationLabel.textAlignment = .center
        noConversationLabel.backgroundColor = UIColor.themeColor
        noConversationLabel.textColor = UIColor.white
        noConversationLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        noConversationLabel.isHidden = true
        return noConversationLabel
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
    
    private func setupNoConversationLabel() {
        noConversationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noConversationLabel)
        NSLayoutConstraint.activate([
            noConversationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noConversationLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noConversationLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
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
            
            return self.searchUserInfo.count
            
        } else {
            
            return userInfo.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = chatRoomListTableView.dequeueReusableCell(withIdentifier: String(describing: "\(ChatroomListTableViewCell.self)"),
                                                                   for: indexPath) as? ChatroomListTableViewCell else { fatalError("No cell") }
        
        guard let photo = userInfo[indexPath.row].photo else {
            fatalError("error")
        }
        
        if searching {
            
            cell.userNameLabel.text = userInfo[indexPath.row].name
            cell.userMessageLabel.text = chatRoomList[indexPath.row].latestMessage.text
            cell.userImageView.kf.setImage(with: URL(string: photo))
            
        } else {
            
            cell.userNameLabel.text = userInfo[indexPath.row].name
            cell.userMessageLabel.text = chatRoomList[indexPath.row].latestMessage.text
            cell.userImageView.kf.setImage(with: URL(string: photo))
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatRoomListTableView.deselectRow(at: indexPath, animated: true)
        
        let chatRoomViewController = ChatRoomViewController()
        
        chatRoomViewController.selectedChatroomId = chatRoomList[indexPath.row].chatRoomId
        
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
            
            guard let userId = userInfo[indexPath.row].userId else {
                return
            }
            FirebaseManger.shared.removeAccepterIdFromSelflikeList(accepterId: userId)
            
            FirebaseManger.shared.postAccepterIdtoSelfDislikeList(accepterId: userId)
            
            userInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "封鎖"
    }
}
