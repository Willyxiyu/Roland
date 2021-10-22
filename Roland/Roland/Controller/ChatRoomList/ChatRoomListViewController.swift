//
//  ChatroomList.swift
//  
//
//  Created by 林希語 on 2021/10/19.
//

import UIKit

class ChatRoomListViewController: UIViewController {
    let chatRoomListTableView = UITableView()
    let chatRoomViewController = ChatRoomPageViewController()
    var friendArray = ["kwe", "jfnkwe", "mfjwkebn", "fkwjebfk", "wenf"]
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRolandLabel()
        setupSearchBarTextFiled()
        setupChatRoomListTableView()
        chatRoomListTableView.dataSource = self
        chatRoomListTableView.delegate = self
        chatRoomListTableView.register(ChatRoomListTableViewCell.self,
        forCellReuseIdentifier: String(describing: ChatRoomListTableViewCell.self))
    }
    // MARK: - UIProperties
    lazy var rolandLabel: UILabel = {
        let rolandLabel = UILabel()
        rolandLabel.textColor = UIColor.themeColor
        rolandLabel.font = UIFont.medium(size: 20)
        rolandLabel.text = "Roland"
        return rolandLabel
    }()
    lazy var searchBarTextFiled: UITextField = {
        let searchBarTextFiled = UITextField()
        searchBarTextFiled.setLeftPaddingPoints(20)
        searchBarTextFiled.placeholder = "Yeeee"
        searchBarTextFiled.layer.cornerRadius = 15
        searchBarTextFiled.backgroundColor = UIColor.secondThemeColor
        return searchBarTextFiled
    }()
    private func setupRolandLabel() {
        rolandLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(rolandLabel)
        NSLayoutConstraint.activate([
            rolandLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            rolandLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40)
        ])
    }
    private func setupSearchBarTextFiled() {
        searchBarTextFiled.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBarTextFiled)
        NSLayoutConstraint.activate([
            searchBarTextFiled.topAnchor.constraint(equalTo: rolandLabel.bottomAnchor, constant: 15),
            searchBarTextFiled.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchBarTextFiled.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            searchBarTextFiled.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupChatRoomListTableView() {
        chatRoomListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chatRoomListTableView)
        NSLayoutConstraint.activate([
            chatRoomListTableView.topAnchor.constraint(equalTo: searchBarTextFiled.bottomAnchor, constant: 20),
            chatRoomListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatRoomListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatRoomListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
extension ChatRoomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}
extension ChatRoomListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatRoomListTableView.dequeueReusableCell(
            withIdentifier: String(describing: "\(ChatRoomListTableViewCell.self)"),
            for: indexPath) as? ChatRoomListTableViewCell else { fatalError("Error") }
        cell.userNameLabel.text = friendArray[indexPath.row]
        return cell
    }
}
