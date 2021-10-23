//
//  NewConversationViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/23.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users......"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let  noResultsLabel = UILabel()
        noResultsLabel.isHidden = true
        noResultsLabel.text = "No Result!"
        noResultsLabel.textAlignment = .center
        noResultsLabel.backgroundColor = UIColor.themeColor
        noResultsLabel.textColor = .white
        noResultsLabel.font = .systemFont(ofSize: 21, weight: .medium)
        return noResultsLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewConversationViewController: UISearchBarDelegate {
    
}
