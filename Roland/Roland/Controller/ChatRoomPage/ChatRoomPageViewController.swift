//
//  ChatroomViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/19.
//

import UIKit

class ChatRoomPageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = .white
        setupBottomBarView()
        setupCameraButton()
        setupPhotoButton()
        setupTextFiled()
        setupMicButton()
    }
    // MARK: - UIProperties
    private lazy var bottomBarView: UIView = {
       let bottomBarView = UIView()
        bottomBarView.backgroundColor = UIColor.themeColor
        return bottomBarView
    }()
    private lazy var cameraButton: UIButton = {
        let cameraButton = UIButton()
        cameraButton.tintColor = UIColor.white
        cameraButton.isEnabled = true
        cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        return cameraButton
    }()
    private lazy var photoButton: UIButton = {
        let photoButton = UIButton()
        photoButton.tintColor = UIColor.white
        photoButton.isEnabled = true
        photoButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        return photoButton
    }()
    private lazy var textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.setLeftPaddingPoints(10)
        textFiled.backgroundColor = UIColor.white
        textFiled.placeholder = "Yeeee"
        textFiled.keyboardType = .default
        textFiled.layer.cornerRadius = 10
        return textFiled
    }()
    private lazy var micButton: UIButton = {
        let micButton = UIButton()
        micButton.tintColor = UIColor.white
        micButton.isEnabled = true
        micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        return micButton
    }()
    private func setupBottomBarView() {
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBarView)
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1)
        ])
    }
    private func setupCameraButton() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 20),
            cameraButton.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 20)
        ])
    }
    private func setupPhotoButton() {
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.addSubview(photoButton)
        NSLayoutConstraint.activate([
            photoButton.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 20),
            photoButton.centerYAnchor.constraint(equalTo: cameraButton.centerYAnchor)
        ])
    }
    private func setupTextFiled() {
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.addSubview(textFiled)
        NSLayoutConstraint.activate([
            textFiled.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor, constant: 20),
            textFiled.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor),
            textFiled.widthAnchor.constraint(equalTo: bottomBarView.widthAnchor, multiplier: 0.6),
            textFiled.heightAnchor.constraint(equalTo: bottomBarView.heightAnchor, multiplier: 0.3)
        ])
    }
    private func setupMicButton() {
        micButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.addSubview(micButton)
        NSLayoutConstraint.activate([
            micButton.leadingAnchor.constraint(equalTo: textFiled.trailingAnchor, constant: 20),
            micButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -20),
            micButton.centerYAnchor.constraint(equalTo: textFiled.centerYAnchor)
        ])
    }
}
