//
//  NewConversationViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/23.
//

import UIKit
import JGProgressHUD
import SwiftUI

class NewConversationViewController: UIViewController {
    
    public var completion: (([String: String]) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: String]]()
    
    private var results = [[String: String]]()
    
    private var hasFetched = false
    
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
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.frame.width / 4,
                                      y: (view.frame.height - 200) / 2,
                                      width: view.frame.width / 2,
                                      height: 200)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
        
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
            
        })
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: "", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        
        spinner.show(in: view)
        
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        //        // check if array has firebase results
        //        if hasFetched {
        //            filterUsers(with: query)
        //        }
        //
        //        else {
        //            FirebaseManger.shared.getUserInfoFromFirestore(completion: { [weak self] result in
        //                switch result {
        //                case .success(let usersCollection):
        //                    self?.users = usersCollection
        //                    self.filterUsers(with: query)
        //                case .failure(let error):
        //                    print("Failed to get users: \(error)")
        //                }
        //        })
        //
        //    }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        
        self.spinner.dismiss()
        
        let results: [[String: String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
