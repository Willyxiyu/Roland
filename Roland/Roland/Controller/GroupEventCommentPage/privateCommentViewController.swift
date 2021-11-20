//
//  privateCommentViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/3.
//

import Foundation
import UIKit
import Firebase

class PrivateCommentViewController: UIViewController {
    
    let tableView = UITableView()
    
    var eventId = String()
    
    var privateComment = [PrivateComment]() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
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
            results.forEach { result in
                self.privateComment.append(result)
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
        
        let date = Date(timeIntervalSince1970: privateComment[indexPath.row].createTime)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        
        cell.messageLabel.text = privateComment[indexPath.row].comment
        cell.dateLabel.text = dateformatter.string(from: date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PrivateCommentFooterView.reuseIdentifier) as? PrivateCommentFooterView else { fatalError("Error") }

        footerView.sendText = { (text) in
            
            FirebaseManger.shared.postPrivateComment(eventId: self.eventId, comment: text)
        }
        
        return footerView
        
        }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 80
    }

}
