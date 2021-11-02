//
//  NotificationViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/2.
//

import Foundation
import UIKit

class NotificationViewController: UIViewController {
    
    let tableView = UITableView()
    let nameList = ["fjkew", "uhfjew", "bhflwey", "ufgwegfde", "wuhdewdwe"]
    var applyList = [ApplyList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupTableView()
        tableView.register(NTFNewRequestCell.self, forCellReuseIdentifier: String(describing: NTFNewRequestCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        FirebaseManger.shared.fetchApplyListforHost(userId: "DoIscQXJzIbQfJDTnBVm") { result in
            self.applyList = result
            self.tableView.reloadData()
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
//        cell.userNameLabel.text = self.applyList[indexPath.row]
        cell.userNameLabel.text = applyList[indexPath.row].requestSenderId
        cell.introLabel.text = "想參加您的\n\(applyList[indexPath.row].eventId))喔！～"
        return cell
    }
}
