//
//  GroupEventCEPEPicVC.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import Foundation
import UIKit
import FirebaseStorage

class UserProfileSignInViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let tableView = UITableView()
    let profileList = ["photo", "name", "email", "intro1", "age", "gender", "intro2"]

    let storage = Storage.storage().reference()
    
    let userProfileAgeTableViewCell = UserProfileAgeTableViewCell()
    
    let userProfileGenderTableViewCell = UserProfileGenderTableViewCell()
    
    var profilePhoto = UIImage() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    var eventUrlString = String() {
        
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
    
}

extension UserProfileSignInViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.userPhotoImageView.image = profilePhoto
            //            cell.userPhotoImageView.image = UIImage(named: "photo")
            cell.view.setShadow()
            cell.userPhotoImageView.image = UIImage.init(systemName: "person.fill")
            
            cell.changePhotoButton.addTarget(self, action: #selector(changeProfilePhoto), for: .touchUpInside)
            return cell
        case 1:
            let info = ["Willy Boy", "willy.xiyu@gmail.com"]
            nameEmailCell.userNameEmailLabel.text = info[0]
            
            return nameEmailCell
            
        case 2:
            let info = ["Willy Boy", "willy.xiyu@gmail.com"]
            nameEmailCell.userNameEmailLabel.text = info[1]
            return nameEmailCell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileFirstIntroTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileFirstIntroTableViewCell else { fatalError("Error") }
            cell.introLabel.text = "I am happy to join with you today in what will go down in history as the greatest demonstration for freedom in the history of our nation."
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileAgeTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileAgeTableViewCell else { fatalError("Error") }
            cell.ageTextField.text = cell.age[0]
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileGenderTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileGenderTableViewCell else { fatalError("Error") }
            cell.genderTextField.text = cell.gender[0]

            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(UserProfileSecondIntroTableViewCell.self)"),
                                                           for: indexPath) as? UserProfileSecondIntroTableViewCell else { fatalError("Error") }
            // swiftlint:disable:next line_length
            cell.introLabel.text = "Five score years ago, a great American, in whose symbolic shadow we stand today, signed the Emancipation Proclamation. This momentous decree came as a great beacon light of hope to millions of Negro slaves who had been seared in the flames of withering injustice. It came as a joyous daybreak to end the long night of their captivity."
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
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        profilePhoto = originalImage
        
        guard let imageData = editedImage.jpegData(compressionQuality: 0.25) else {
            return
        }
        
        let uniqueString = NSUUID().uuidString
        storage.child("imgae/\(uniqueString)").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("imgae/\(uniqueString)").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self.eventUrlString = urlString
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        }
    }
}