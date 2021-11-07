//
//  ProfilePageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/31.
//

import Foundation
import UIKit
import Lottie

class ProfilePageViewController: UIViewController {
//    let animationView = AnimationView(name: "72933-likelove-icon-micro-interaction")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
//        self.setBackgroundImage(imageName: "profilePic")
        setupPhotoBackgroundview()
        setupUserPhotoImageView()
        setupNewPhotoBackgroundView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        photoBackgroundView.layer.cornerRadius = UIScreen.main.bounds.width / 4
        userPhotoImageView.layer.masksToBounds = true
        userPhotoImageView.layer.cornerRadius = UIScreen.main.bounds.width / 4
        newPhotoBackgroundView.layer.cornerRadius = UIScreen.main.bounds.width * 0.15
        
//        UIScreen.main.bounds.width / 4
        
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
        settingBackgroundView.backgroundColor = .green
        settingBackgroundView.clipsToBounds = true
        settingBackgroundView.setShadow()
        return settingBackgroundView
    }()
    
    lazy var newPhotoBackgroundView: UIView = {
        let newPhotoBackgroundView = UIView()
        newPhotoBackgroundView.backgroundColor = .blue
        newPhotoBackgroundView.clipsToBounds = true
        newPhotoBackgroundView.setShadow()
        return newPhotoBackgroundView
    }()
    
    lazy var editInfoBackgroundView: UIView = {
        let editInfoBackgroundView = UIView()
        editInfoBackgroundView.backgroundColor = .red
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
    
    private func setupUserPhotoImageView() {
        userPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userPhotoImageView)
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
//            userPhotoImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            userPhotoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            userPhotoImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupPhotoBackgroundview() {
        photoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(photoBackgroundView)
        NSLayoutConstraint.activate([
            photoBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
//            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            photoBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            photoBackgroundView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            photoBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupNewPhotoBackgroundView() {
        newPhotoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newPhotoBackgroundView)
        NSLayoutConstraint.activate([
            newPhotoBackgroundView.topAnchor.constraint(equalTo: photoBackgroundView.bottomAnchor, constant: 100),
            newPhotoBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            newPhotoBackgroundView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            newPhotoBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
        ])
    }
    
}
