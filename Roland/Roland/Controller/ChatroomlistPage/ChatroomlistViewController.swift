//
//  ChatroomlistViewController.swift
//  
//
//  Created by 林希語 on 2021/10/22.
//

import UIKit
import JGProgressHUD

class ChatroomlistViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    var nameList = ["Willy Boy"]
    
    override func viewDidLoad() {
        setupChatRoomListTableView()
        setupNoConversationLabel()
        fetchConversation()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
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
        
        guard let name = result["name"],
        let email = result["email"] else {
            return
        }
        let chatRoomViewController = ChatRoomViewController(with: email)
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
        chatRoomListTableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: String(describing: ChatRoomTableViewCell.self))
        chatRoomListTableView.dataSource = self
        chatRoomListTableView.delegate = self
        
        NSLayoutConstraint.activate([
            chatRoomListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
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
    
    private func fetchConversation() {
        
    }
}

extension ChatroomlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    guard let cell = chatRoomListTableView.dequeueReusableCell(withIdentifier: String(describing: "\(ChatRoomTableViewCell.self)"),
        for: indexPath) as? ChatRoomTableViewCell else { fatalError("No cell") }
        cell.cellLabel.text = nameList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatRoomListTableView.deselectRow(at: indexPath, animated: true)
        
        let chatRoomViewController = ChatRoomViewController(with: "willy@gmail.com")
        chatRoomViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
// headerView want to put the searchBar
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        <#code#>
//    }
    
}
