//
//  ProfilePageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/31.
//

import Foundation
import UIKit
import Lottie
import FirebaseStorage
import Kingfisher
import SafariServices
import FirebaseAuth

class ProfilePageViewController: UIViewController {
    //    let animationView = AnimationView(name: "72933-likelove-icon-micro-interaction")
    private let storage = Storage.storage().reference()
    private let gradientLayer = CAGradientLayer()
    
    var eventUrlString = String() {
        
        didSet {
            
            guard let userInfo = userInfo else {
                
                return
            }
            
            FirebaseManger.shared.updateUserInfo(name: userInfo.name, email: userInfo.email, age: userInfo.age, gender: userInfo.gender, photo: eventUrlString)
            
            FirebaseManger.shared.fetchUserInfobyUserId { result in
                self.userInfo = result
            }
        }
    }
    
    var userInfo: UserInfo? {
        
        didSet {
            
            guard let userProfilePhoto = userInfo?.photo else {
                
                return
            }
            
            userPhotoImageView.kf.setImage(with: URL(string: userProfilePhoto ))
            
            self.reloadInputViews()
            
            if let userName = userInfo?.name {
                
                userNameLabel.text = userName
                
            }
            
        }
    }
    
    var profilePhoto = UIImage() {
        
        didSet {
            
            userPhotoImageView.image = profilePhoto
            
            self.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        setupPhotoBackgroundview()
        setupUserPhotoImageView()
        setupNewPhotoBackgroundView()
        setupGradientLayer()
        setupSettingBackgroundView()
        setupEditInfoBackgroundView()
        setupUserNameLabel()
        setupSettingLabel()
        setupNewPhotoLabel()
        setupEditInfoLabel()
        setupSettingButton()
        setupNewPhotoButton()
        setupEditInfoButton()
        setupLogOutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        FirebaseManger.shared.fetchUserInfobyUserId { result in
            self.userInfo = result
        }
        //        setupAnimation()
    }
    //
    //    func setupAnimation() {
    //
    //        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    //        animationView.center = self.view.center
    //        animationView.contentMode = .scaleAspectFill
    //        animationView.loopMode = .loop
    //        animationView.animationSpeed = 0.75
    //        view.addSubview(animationView)
    //        animationView.play()
    //    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = newPhotoBackgroundView.bounds
        gradientLayer.cornerRadius = UIScreen.main.bounds.width * 0.2 * 0.5
        photoBackgroundView.layer.cornerRadius = UIScreen.main.bounds.width / 4
        userPhotoImageView.layer.masksToBounds = true
        userPhotoImageView.layer.cornerRadius = UIScreen.main.bounds.width / 4
        newPhotoBackgroundView.layer.cornerRadius = UIScreen.main.bounds.width * 0.2 * 0.5
        settingBackgroundView.layer.cornerRadius = UIScreen.main.bounds.width * 0.15 * 0.5
        editInfoBackgroundView.layer.cornerRadius = UIScreen.main.bounds.width * 0.15 * 0.5
        
    }
    // MARK: - backgroundView fot the shadow
    lazy var photoBackgroundView: UIView = {
        let photoBackgroundView = UIView()
        photoBackgroundView.backgroundColor = .systemGray6
        photoBackgroundView.clipsToBounds = true
        photoBackgroundView.setShadow()
        return photoBackgroundView
    }()
    
    lazy var settingBackgroundView: UIView = {
        let settingBackgroundView = UIView()
        settingBackgroundView.backgroundColor = .systemGray6
        settingBackgroundView.clipsToBounds = true
        settingBackgroundView.setShadow()
        return settingBackgroundView
    }()
    
    lazy var newPhotoBackgroundView: UIView = {
        let newPhotoBackgroundView = UIView()
        newPhotoBackgroundView.backgroundColor = .systemGray6
        newPhotoBackgroundView.clipsToBounds = true
        newPhotoBackgroundView.setShadow()
        return newPhotoBackgroundView
    }()
    
    lazy var editInfoBackgroundView: UIView = {
        let editInfoBackgroundView = UIView()
        editInfoBackgroundView.backgroundColor = .systemGray6
        editInfoBackgroundView.clipsToBounds = true
        editInfoBackgroundView.setShadow()
        return editInfoBackgroundView
    }()
    
    // MARK: - item on the backgroundView
    
    lazy var userPhotoImageView: UIImageView = {
        let userPhotoImageView = UIImageView()
        userPhotoImageView.tintColor = .white
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.clipsToBounds = true
        return userPhotoImageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        userNameLabel.textAlignment = .center
        return userNameLabel
    }()
    
    lazy var settingLabel: UILabel = {
        let settingLabel = UILabel()
        settingLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        settingLabel.textAlignment = .center
        settingLabel.text = "隱私政策"
        return settingLabel
    }()
    
    lazy var newPhotoLabel: UILabel = {
        let newPhotoLabel = UILabel()
        newPhotoLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        newPhotoLabel.textAlignment = .center
        newPhotoLabel.text = "新增照片"
        return newPhotoLabel
    }()
    
    lazy var editInfoLabel: UILabel = {
        let editInfoLabel = UILabel()
        editInfoLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        editInfoLabel.textAlignment = .center
        editInfoLabel.text = "編輯資訊"
        return editInfoLabel
    }()
    
    lazy var settingButton: UIButton = {
        let settingButton = UIButton(type: .custom)
        settingButton.setImage(UIImage(named: "settingButton"), for: .normal)
        settingButton.layer.masksToBounds = true
        settingButton.alpha = 0.7
        settingButton.addTarget(self, action: #selector(setting), for: .touchUpInside)
        return settingButton
    }()
    
    @objc func setting() {
        
        guard let url = URL(string: "https://www.privacypolicies.com/live/c00148f6-b426-435c-a4d8-dd4e599b9e25") else { return }
        
        let svc = SFSafariViewController(url: url)
        
        present(svc, animated: true, completion: nil)
        
        //        let vc = SettingPageViewController() // change this to your class name
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true, completion: nil)
    }
    
    lazy var newPhotoButton: UIButton = {
        let newPhotoButton = UIButton(type: .system)
        newPhotoButton.setImage(UIImage(named: "camera"), for: .normal)
        newPhotoButton.tintColor = UIColor.white
        newPhotoButton.layer.masksToBounds = true
        newPhotoButton.addTarget(self, action: #selector(newPhoto), for: .touchUpInside)
        return newPhotoButton
    }()
    
    @objc func newPhoto() {
        showImagePickerControllerActionSheet()
    }
    
    lazy var editInfoButton: UIButton = {
        let editInfoButton = UIButton()
        editInfoButton.setImage(UIImage(named: "editInfo"), for: .normal)
        editInfoButton.layer.masksToBounds = true
        editInfoButton.alpha = 0.7
        editInfoButton.addTarget(self, action: #selector(editInfo), for: .touchUpInside)
        return editInfoButton
    }()
    
    @objc func editInfo() {
        
        let viewController = NotReadyPageViewController() // change this to your class name
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    lazy var logOutButton: UIButton = {
        let logOutButton = UIButton()
        logOutButton.setTitle("登出帳號", for: .normal)
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.layer.masksToBounds = true
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return logOutButton
    }()
    
    @objc func logOut() {
        print("logout")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewContoller")

        guard let loginVC = loginVC as? SignInViewContoller else { return }

        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
                    window.rootViewController = loginVC
                    window.makeKeyAndVisible()

    }

    private func setupLogOutButton() {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func setupUserPhotoImageView() {
        userPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userPhotoImageView)
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            userPhotoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            userPhotoImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupPhotoBackgroundview() {
        photoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(photoBackgroundView)
        NSLayoutConstraint.activate([
            photoBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            photoBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            photoBackgroundView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            photoBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupNewPhotoBackgroundView() {
        newPhotoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newPhotoBackgroundView)
        NSLayoutConstraint.activate([
            newPhotoBackgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50),
            newPhotoBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            newPhotoBackgroundView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
            newPhotoBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupSettingBackgroundView() {
        settingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(settingBackgroundView)
        NSLayoutConstraint.activate([
            settingBackgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            settingBackgroundView.centerXAnchor.constraint(equalTo: photoBackgroundView.leadingAnchor),
            settingBackgroundView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15),
            settingBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15)
        ])
    }
    
    private func setupEditInfoBackgroundView() {
        editInfoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editInfoBackgroundView)
        NSLayoutConstraint.activate([
            editInfoBackgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            editInfoBackgroundView.centerXAnchor.constraint(equalTo: photoBackgroundView.trailingAnchor),
            editInfoBackgroundView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15),
            editInfoBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15)
        ])
    }
    
    private func setupUserNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: photoBackgroundView.bottomAnchor, constant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: photoBackgroundView.centerXAnchor)
        ])
    }
    
    private func setupSettingLabel() {
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(settingLabel)
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: settingBackgroundView.bottomAnchor, constant: 15),
            settingLabel.centerXAnchor.constraint(equalTo: settingBackgroundView.centerXAnchor)
            
        ])
    }
    
    private func setupNewPhotoLabel() {
        newPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newPhotoLabel)
        NSLayoutConstraint.activate([
            newPhotoLabel.topAnchor.constraint(equalTo: newPhotoBackgroundView.bottomAnchor, constant: 15),
            newPhotoLabel.centerXAnchor.constraint(equalTo: newPhotoBackgroundView.centerXAnchor)
        ])
    }
    
    private func setupEditInfoLabel() {
        editInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editInfoLabel)
        NSLayoutConstraint.activate([
            editInfoLabel.topAnchor.constraint(equalTo: editInfoBackgroundView.bottomAnchor, constant: 15),
            editInfoLabel.centerXAnchor.constraint(equalTo: editInfoBackgroundView.centerXAnchor)
        ])
    }
    
    private func setupSettingButton() {
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingBackgroundView.addSubview(settingButton)
        NSLayoutConstraint.activate([
            settingButton.centerXAnchor.constraint(equalTo: settingBackgroundView.centerXAnchor),
            settingButton.centerYAnchor.constraint(equalTo: settingBackgroundView.centerYAnchor),
            settingButton.widthAnchor.constraint(equalTo: settingBackgroundView.widthAnchor, multiplier: 0.6),
            settingButton.heightAnchor.constraint(equalTo: settingBackgroundView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupNewPhotoButton() {
        newPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        newPhotoBackgroundView.addSubview(newPhotoButton)
        NSLayoutConstraint.activate([
            newPhotoButton.centerXAnchor.constraint(equalTo: newPhotoBackgroundView.centerXAnchor),
            newPhotoButton.centerYAnchor.constraint(equalTo: newPhotoBackgroundView.centerYAnchor),
            newPhotoButton.widthAnchor.constraint(equalTo: newPhotoBackgroundView.widthAnchor, multiplier: 0.6),
            newPhotoButton.heightAnchor.constraint(equalTo: newPhotoBackgroundView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupEditInfoButton() {
        editInfoButton.translatesAutoresizingMaskIntoConstraints = false
        editInfoBackgroundView.addSubview(editInfoButton)
        NSLayoutConstraint.activate([
            editInfoButton.centerXAnchor.constraint(equalTo: editInfoBackgroundView.centerXAnchor),
            editInfoButton.centerYAnchor.constraint(equalTo: editInfoBackgroundView.centerYAnchor),
            editInfoButton.widthAnchor.constraint(equalTo: editInfoBackgroundView.widthAnchor, multiplier: 0.6),
            editInfoButton.heightAnchor.constraint(equalTo: editInfoBackgroundView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: "fff0f3").cgColor, UIColor.hexStringToUIColor(hex: "ff4d6d").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0.0, 1.0]
        newPhotoBackgroundView.layer.addSublayer(gradientLayer)
    }
    
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
