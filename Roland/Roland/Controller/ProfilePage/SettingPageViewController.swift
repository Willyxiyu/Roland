//
//  SettingPageViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/17.
//

import UIKit
import SafariServices

class SettingCategory {
    var settingSection: String?
    var settingItems: [String]?
    
    init(settingSection: String, settingItems: [String]) {
        self.settingSection = settingSection
        self.settingItems = settingItems
    }
}

class SettingPageViewController: UIViewController {
    
    let tableView = UITableView()
    
    var settingCategory = [SettingCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCategory.append(SettingCategory.init(settingSection: "帳號設定", settingItems: ["電話號碼", "電子郵件"]))
        settingCategory.append(SettingCategory.init(settingSection: "聯絡我們", settingItems: ["說明＆支援"]))
        settingCategory.append(SettingCategory.init(settingSection: "社群", settingItems: ["社群規範", "安全小秘訣"]))
        settingCategory.append(SettingCategory.init(settingSection: "法務", settingItems: ["隱私政策", "服務條款", "授權", "隱私偏好設定"]))
        
        view.backgroundColor = .systemGray6
        setupSettingPageTitleLabel()
        setupCloseSettingPageButton()
        setupLogoutButton()
        tableView.register(SettingPageTableViewCell.self, forCellReuseIdentifier: String(describing: SettingPageTableViewCell.self))
        setupTableView()
        setupDeleteAccountButton()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    lazy var settingPageTitleLabel: UILabel = {
        let settingPageTitleLabel = UILabel()
        settingPageTitleLabel.text = "設定"
        settingPageTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        settingPageTitleLabel.textAlignment = .center
        
        return settingPageTitleLabel
    }()
    lazy var closeSettingPageButton: UIButton = {
        let closeSettingPageButton = UIButton()
        closeSettingPageButton.setBackgroundImage(UIImage.init(systemName: "x.circle"), for: .normal)
        closeSettingPageButton.tintColor = .black
        closeSettingPageButton.addTarget(self, action: #selector(closeSettingPage), for: .touchUpInside)
        return closeSettingPageButton
    }()
    
    @objc func closeSettingPage() {
        print("OK")
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var logoutButton: UIButton = {
        let logOutButton = UIButton()
        logOutButton.setTitle("登出", for: .normal)
        logOutButton.setTitleColor(UIColor.white, for: .normal)
        logOutButton.backgroundColor = .themeColor
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        logOutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return logOutButton
    }()
    
    @objc func logout() {
        
    }
    
    lazy var deleteAccountButton: UIButton = {
        let deleteAccountButton = UIButton()
        deleteAccountButton.setTitle("刪除帳號", for: .normal)
        deleteAccountButton.setTitleColor(UIColor.black, for: .normal)
        deleteAccountButton.backgroundColor = UIColor.white
        deleteAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        return deleteAccountButton
    }()
    
    @objc func deleteAccount() {
        
    }
    
    private func setupCloseSettingPageButton() {
        closeSettingPageButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeSettingPageButton)
        NSLayoutConstraint.activate([
            closeSettingPageButton.centerYAnchor.constraint(equalTo: settingPageTitleLabel.centerYAnchor),
            closeSettingPageButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeSettingPageButton.heightAnchor.constraint(equalToConstant: 30),
            closeSettingPageButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupSettingPageTitleLabel() {
        settingPageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(settingPageTitleLabel)
        NSLayoutConstraint.activate([
            settingPageTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingPageTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: settingPageTitleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor)
        ])
    }
    
    private func setupLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            logoutButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            logoutButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupDeleteAccountButton() {
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(deleteAccountButton)
        NSLayoutConstraint.activate([
            deleteAccountButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            deleteAccountButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            deleteAccountButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            deleteAccountButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.1)
        ])
    }
    
}

extension SettingPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return settingCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingCategory[section].settingItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(SettingPageTableViewCell.self)"),
                                                       for: indexPath) as? SettingPageTableViewCell else { fatalError("error") }
        
        cell.settingItemsLabel.text = settingCategory[indexPath.section].settingItems?[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return settingCategory[section].settingSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        view.backgroundColor = .systemGray6
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        
        label.text = settingCategory[section].settingSection
        
        label.textColor = .systemGray
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0 :
            
            switch indexPath.row {
                
            case 0 :
                
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            case 1 :
                
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            default: break
                
            }
            
        case 1 :
            
            switch indexPath.row {
                
            case 0 :
                
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            default: break
                
            }
            
        case 2 :
            
            switch indexPath.row {
                
            case 0 :
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            case 1 :
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            default: break
                
            }
            
        case 3 :
            
            switch indexPath.row {
                
            case 0 :
                
                guard let url = URL(string: "https://www.privacypolicies.com/live/c00148f6-b426-435c-a4d8-dd4e599b9e25") else { return }
                
                let svc = SFSafariViewController(url: url)
                
                present(svc, animated: true, completion: nil)
                
                print("3.0")
                
            case 1 :
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)

            case 2 :
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)

            case 3 :
                let vc = NotReadyPageViewController() // change this to your class name
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)

            default: break
            }
            
        default: break
            
        }
        
    }
}
