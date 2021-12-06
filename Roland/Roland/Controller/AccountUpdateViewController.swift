//
//  AccountUpdateViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/12/5.
//

import UIKit
import FirebaseStorage

class AccountUpdateViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let tableView = UITableView()
    
    let userProfileAgeTableViewCell = UserProfileAgeTableViewCell()
    
    let userProfileGenderTableViewCell = UserProfileGenderTableViewCell()
    
    let titleLabel = UILabel()
    
    var userName: String?
    
    var userEmail: String?
    
    var userIntro: String?
    
    var userAge: String?
    
    var userGender: String?
    
    var userInfo: UserInfo?
    
    let profileList: [String] = ["name", "email", "inro", "intro1", "age", "gender", "intro2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        FirebaseManger.shared.fetchUserInfobyUserId { userInfo in
            
            if let userInfo =  userInfo {
                
                self.userName = userInfo.name
                
                self.userEmail = userInfo.email
                
                self.userIntro = userInfo.intro
                
                self.userAge = userInfo.age
                
                self.userGender = userInfo.gender
                
                self.tableView.reloadData()
            }
        }
        
        self.hideKeyboardWhenTappedAround()
        setupCloseSettingPageButton()
        setupTitleLabel()
        setupTableView()
        setupUpdateUserInfoButton()
        finishEdit()
        
        tableView.register(UserProfileNameEmailTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileNameEmailTableViewCell.self))
        
        tableView.register(UserProfileFirstIntroTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileFirstIntroTableViewCell.self))
        
        tableView.register(UserProfileAgeTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileAgeTableViewCell.self))
        
        tableView.register(UserProfileGenderTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileGenderTableViewCell.self))
        
        tableView.register(UserProfileSecondIntroTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileSecondIntroTableViewCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        // Do any additional setup after loading the view.
    }
    
    lazy var closeSettingPageButton: UIButton = {
        let closeSettingPageButton = UIButton()
        closeSettingPageButton.setBackgroundImage(UIImage.init(systemName: "x.circle"), for: .normal)
        closeSettingPageButton.tintColor = .themeColor
        closeSettingPageButton.addTarget(self, action: #selector(closeSettingPage), for: .touchUpInside)
        return closeSettingPageButton
    }()
    
    @objc func closeSettingPage() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var updateUserInfoButton: UIButton = {
        let updateUserInfoButton = UIButton()
        updateUserInfoButton.setTitle("確認更新", for: .normal)
        updateUserInfoButton.setTitleColor(.gray, for: .normal)
        updateUserInfoButton.layer.masksToBounds = true
        updateUserInfoButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        updateUserInfoButton.backgroundColor = .themeColor
        updateUserInfoButton.layer.cornerRadius = 5
//        updateUserInfoButton.isEnabled = true
        return updateUserInfoButton
    }()
    
    @objc func update() {
        
        guard let userName = userName,
                  let userEmail = userEmail,
                  let userAge = userAge,
                  let userGender = userGender,
                  let userIntro = userIntro else {  return }
        
        FirebaseManger.shared.updateUserInfoIneditPage(name: userName, email: userEmail, age: userAge, gender: userGender, intro: userIntro)
        
        self.dismiss(animated: true, completion: nil)
        
        print("update")
    }
    
    private func setupUpdateUserInfoButton() {
        updateUserInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(updateUserInfoButton)
        NSLayoutConstraint.activate([
            updateUserInfoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            updateUserInfoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            updateUserInfoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: closeSettingPageButton.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    private func setupCloseSettingPageButton() {
        closeSettingPageButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeSettingPageButton)
        NSLayoutConstraint.activate([
            closeSettingPageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35),
            closeSettingPageButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeSettingPageButton.heightAnchor.constraint(equalToConstant: 30),
            closeSettingPageButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: closeSettingPageButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        titleLabel.text = "編輯資訊"
    }
}

extension AccountUpdateViewController: UITableViewDataSource, UITableViewDelegate, CellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nameEmailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileNameEmailTableViewCell.self)"),
                                                                for: indexPath) as? UserProfileNameEmailTableViewCell else { fatalError("Error") }
        switch indexPath.row {
        case 0:
            
            nameEmailCell.userNameEmailTextField.setLeftPaddingPoints(0)
            
            nameEmailCell.userNameEmailTextField.placeholder = "姓名"
            
            nameEmailCell.userNameEmailTextField.text = userName
            
            nameEmailCell.name = .nameCell
            
            nameEmailCell.delegate = self
            
            nameEmailCell.userNameEmailTextField.tag = indexPath.row
            
            return nameEmailCell
            
        case 1:
            
            nameEmailCell.userNameEmailTextField.setLeftPaddingPoints(0)
            
            nameEmailCell.userNameEmailTextField.placeholder = "email"
            
            nameEmailCell.userNameEmailTextField.text = userEmail
            
            nameEmailCell.name = .emailCell
            
            nameEmailCell.delegate = self
            
            nameEmailCell.userNameEmailTextField.tag = indexPath.row
            
            return nameEmailCell
            
        case 2:
            
            nameEmailCell.userNameEmailTextField.setLeftPaddingPoints(0)
            
            nameEmailCell.userNameEmailTextField.placeholder = "跟大家分享你自己的簡介"
            
            nameEmailCell.userNameEmailTextField.text = userIntro
            
            nameEmailCell.name = .introCell
            
            nameEmailCell.delegate = self
            
            nameEmailCell.userNameEmailTextField.tag = indexPath.row
            
            return nameEmailCell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileFirstIntroTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileFirstIntroTableViewCell else { fatalError("Error") }
            cell.introLabel.text = "所留資訊，請勿包含言語暴力、霸凌、歧視等用語，讓我們共同維護這個美好的環境，簡介是讓對方快速認識你，很好的開始喔"
            
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileAgeTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileAgeTableViewCell else { fatalError("Error") }
//            cell.ageTextField.text = cell.age[0]
            
            cell.ageTextField.text = self.userAge
            
            userAge = cell.ageTextField.text
            
            cell.delegate = self
            
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileGenderTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileGenderTableViewCell else { fatalError("Error") }
//            cell.genderTextField.text = cell.gender[0]
            
            cell.genderTextField.text = self.userGender
            
            userGender = cell.genderTextField.text
            
            cell.delegate = self
            
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileSecondIntroTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileSecondIntroTableViewCell else { fatalError("Error") }
            cell.introLabel.text = "年齡與性別可以幫助我們在未來有篩選功能時，能夠讓您篩選相關的數據與資訊"
            return cell
        default:
            break
            
        }
                
        return UITableViewCell()
        
    }
    
    func nameChange(name: String?) {
        userName = name
        
        finishEdit()
    }
    
    func emailChange(email: String?) {
        userEmail = email
        
        finishEdit()

    }
    
    func introChange(intro: String?) {
        userIntro = intro
        
        finishEdit()

    }
    func finishEdit() {
        
        if userName != "" && userEmail != "" && userIntro != "" {
            updateUserInfoButton.isEnabled = true
            updateUserInfoButton.setTitleColor(.white, for: .normal)
        } else {
            updateUserInfoButton.isEnabled = false
            updateUserInfoButton.setTitleColor(.gray, for: .normal)
        }
    }

}

extension AccountUpdateViewController: PickerViewDelegate {
    
    func ageForPicker(age: String) {
        userAge = age
    }
    
    func genderForPicker(gender: String) {
        userGender = gender
    }
    
}
