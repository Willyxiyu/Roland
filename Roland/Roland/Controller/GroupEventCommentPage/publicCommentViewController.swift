//
//  publicCommentViewController.swift
//  
//
//  Created by 林希語 on 2021/11/3.
//

import Foundation
import UIKit

class PublicCommentViewController: UIViewController {
    
    let tableView = UITableView()
    
    var messageList = [String]() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
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
        
        return messageList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPCommentCell.self)"), for: indexPath) as? GEPCommentCell else { fatalError("Error") }
        
        cell.messageLabel.text = messageList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PublicCommentFooterView.reuseIdentifier) as? PublicCommentFooterView else { fatalError("Error") }

        footerView.sendText = { (text) in
            
            self.messageList.append(text)
        }
        
        return footerView
        
        }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 80
    }

}
