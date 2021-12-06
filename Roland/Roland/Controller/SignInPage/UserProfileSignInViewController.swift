//
//  GroupEventCEPEPicVC.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth

class UserProfileSignInViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    let tableView = UITableView()
    
    let userProfileAgeTableViewCell = UserProfileAgeTableViewCell()
    
    let userProfileGenderTableViewCell = UserProfileGenderTableViewCell()
        
    let profileList: [String] = ["photo", "name", "email", "intro1", "age", "gender", "intro2"]
            
    var userName: String?
    
    var userEmail: String?
    
    var userIntro: String?
    
    var userAge: String?
    
    var userGender: String?
    
    var profilePhoto = UIImage() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    var eventUrlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "Your details"
        self.view.backgroundColor = .white
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        self.hideKeyboardWhenTappedAround()
        setupTableView()
        tableView.register(UserProfilePhotoTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfilePhotoTableViewCell.self))
        
        tableView.register(UserProfileNameEmailTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileNameEmailTableViewCell.self))
        
        tableView.register(UserProfileFirstIntroTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileFirstIntroTableViewCell.self))
        
        tableView.register(UserProfileAgeTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileAgeTableViewCell.self))
        
        tableView.register(UserProfileGenderTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileGenderTableViewCell.self))
        
        tableView.register(UserProfileSecondIntroTableViewCell.self, forCellReuseIdentifier: String(describing: UserProfileSecondIntroTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(createNewProfile))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    @objc func createNewProfile() {
        
        guard let userName = userName else { return }
        guard let userEmail = userEmail else { return }
        guard let userAge = userAge else { return }
        guard let userGender = userGender else { return }
        FirebaseManger.shared.postNewUserInfo(name: userName, gender: userGender, age: userAge, photo: profilePhoto, email: userEmail)
        
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
        
        guard let tabBarVC = tabBarVC as? TabBarViewController else { return }
        
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
                    window.rootViewController = tabBarVC
                    window.makeKeyAndVisible()
            
    }
    
}

extension UserProfileSignInViewController: UITableViewDataSource, UITableViewDelegate, CellDelegate {
    func introChange(intro: String?) {
        userIntro = intro
    }
    
    func nameChange(name: String?) {
        
        userName = name
    }
    
    func emailChange(email: String?) {
        
        userEmail = email
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nameEmailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileNameEmailTableViewCell.self)"),
                                                                for: indexPath) as? UserProfileNameEmailTableViewCell else { fatalError("Error") }
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfilePhotoTableViewCell.self)"),
                                                           for: indexPath) as? UserProfilePhotoTableViewCell else { fatalError("Error") }
            
            cell.view.setShadow()
            
            cell.userPhotoImageView.image = profilePhoto
            
            cell.changePhotoButton.addTarget(self, action: #selector(changeProfilePhoto), for: .touchUpInside)
            
            return cell
            
        case 1:
            
            nameEmailCell.userNameEmailTextField.placeholder = "姓名"
            
            nameEmailCell.userNameEmailTextField.text = userName
                                    
            nameEmailCell.name = .nameCell
            
            nameEmailCell.delegate = self
            
            return nameEmailCell
            
        case 2:
            
            nameEmailCell.userNameEmailTextField.placeholder = "email"
            
            nameEmailCell.userNameEmailTextField.text = userEmail
                        
            nameEmailCell.name = .emailCell
            
            nameEmailCell.delegate = self
            
            return nameEmailCell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileFirstIntroTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileFirstIntroTableViewCell else { fatalError("Error") }
            cell.introLabel.text = "所留資訊，請勿包含言語暴力、霸凌、歧視等用語，讓我們共同維護這個美好的環境，簡介是讓對方第一任是你的地方喔！"
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileAgeTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileAgeTableViewCell else { fatalError("Error") }
            cell.ageTextField.text = cell.age[0]
            
            userAge = cell.ageTextField.text
            
            cell.delegate = self
            
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileGenderTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileGenderTableViewCell else { fatalError("Error") }
            cell.genderTextField.text = cell.gender[0]
            
            userGender = cell.genderTextField.text
            
            cell.delegate = self
            
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileSecondIntroTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileSecondIntroTableViewCell else { fatalError("Error") }
            // swiftlint:disable:next line_length
            cell.introLabel.text = "年齡與性別可以幫助我們在未來有篩選功能時，能夠讓您篩選相關的數據與資訊"
            return cell
        default:
            break
            
        }
        
        return UITableViewCell()
    }
    
    @objc func changeProfilePhoto() {
        showImagePickerControllerActionSheet()
    }
    
}

extension UserProfileSignInViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Photo", message: "where would you like to attach a photo from", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        profilePhoto = editedImage
        
//        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//
//        profilePhoto = originalImage
        
//        guard let imageData = editedImage.jpegData(compressionQuality: 0.25) else {
//            return
//        }
//
//        let uniqueString = NSUUID().uuidString
//        storage.child("imgae/\(uniqueString)").putData(imageData, metadata: nil) { _, error in
//            guard error == nil else {
//                print("Failed to upload")
//                return
//            }
//            self.storage.child("imgae/\(uniqueString)").downloadURL(completion: { url, error in
//                guard let url = url, error == nil else {
//                    return
//                }
//                let urlString = url.absoluteString
//                print("Download URL: \(urlString)")
//                self.eventUrlString = urlString
//                UserDefaults.standard.set(urlString, forKey: "url")
//            })
//        }
    }
}

extension UserProfileSignInViewController: PickerViewDelegate {
    
    func ageForPicker(age: String) {
        
        userAge = age
    }
    
    func genderForPicker(gender: String) {
        
        userGender = gender
    }
    
}
