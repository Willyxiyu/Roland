//
//  CardView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
//

import UIKit

class CardHomePageView: UIView {
    // MARK: - UIProperties
    lazy var rolandLabel: UILabel = {
        let rolandLabel = UILabel()
        rolandLabel.textColor = UIColor.themeColor
        rolandLabel.font = UIFont.medium(size: 20)
        rolandLabel.text = "Roland"
        return rolandLabel
    }()
    lazy var cardView: UIImageView = {
        let cardView = UIImageView()
        cardView.image = UIImage(named: "photo")
        cardView.contentMode = .scaleAspectFill
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 15
        return cardView
    }()
    lazy var cardIcon: UIImageView = {
        let cardIcon = UIImageView()
        cardIcon.image = UIImage(named: "heart")
        cardIcon.alpha = 0
        return cardIcon
    }()
    lazy var addUserInfoButton: UIButton = {
        let addUserInfoButton = UIButton()
        addUserInfoButton.setTitle("addNewUser", for: .normal)
        addUserInfoButton.setTitleColor(UIColor.themeColor, for: .normal)
        addUserInfoButton.titleLabel?.font = UIFont.medium(size: 20)
        addUserInfoButton.isEnabled = true
        addUserInfoButton.addTarget(self, action: #selector(addNewUser), for: .touchUpInside)
        return addUserInfoButton
    }()
    @objc func addNewUser() {
        FirebaseManger.shared.addUserInfo()
    }
    
    lazy var getUserInfoButton: UIButton = {
        let getUserInfoButton = UIButton()
        getUserInfoButton.setTitle("getUserInfo", for: .normal)
        getUserInfoButton.setTitleColor(UIColor.themeColor, for: .normal)
        getUserInfoButton.titleLabel?.font = UIFont.medium(size: 15)
        getUserInfoButton.isEnabled = true
        getUserInfoButton.addTarget(self, action: #selector(getUserInfo), for: .touchUpInside)
        return getUserInfoButton
    }()
    @objc func getUserInfo() {
        FirebaseManger.shared.getUserInfo {
            result in
        }
    }
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.textColor = UIColor.white
        nameLabel.text = "WillyBoy"
        return nameLabel
    }()
    
    lazy var birthLabel: UILabel = {
        let birthLabel = UILabel()
        birthLabel.font = UIFont.medium(size: 20)
        birthLabel.textColor = UIColor.white
        birthLabel.text = "26"
       return birthLabel
    }()
    
    // MARK: - init
    init() {
      super.init(frame: .zero)
        setupRolandLabel()
        setupCardView()
        setupCardIcon()
        setupAddUserInfoButton()
        setupGetUserInfoButton()
        setupNameLabel()
        setupBirthLabel()
    }
    required init?(coder: NSCoder) {
      fatalError()
    }
    // MARK: - configUI method
    private func setupRolandLabel() {
        rolandLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rolandLabel)
        NSLayoutConstraint.activate([
            rolandLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            rolandLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40)
        ])
    }
    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ])
    }
    private func setupCardIcon() {
        cardIcon.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardIcon)
        NSLayoutConstraint.activate([
            cardIcon.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardIcon.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3),
            cardIcon.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3)
        ])
    }
    private func setupAddUserInfoButton() {
        addUserInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addUserInfoButton)
        NSLayoutConstraint.activate([
            addUserInfoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addUserInfoButton.centerYAnchor.constraint(equalTo: rolandLabel.centerYAnchor),
            addUserInfoButton.heightAnchor.constraint(equalToConstant: 50),
            addUserInfoButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupGetUserInfoButton() {
        getUserInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(getUserInfoButton)
        NSLayoutConstraint.activate([
            getUserInfoButton.centerYAnchor.constraint(equalTo: addUserInfoButton.centerYAnchor),
            getUserInfoButton.leadingAnchor.constraint(equalTo: addUserInfoButton.trailingAnchor, constant: 20),
            getUserInfoButton.widthAnchor.constraint(equalToConstant: 80),
            getUserInfoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 50),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -100),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupBirthLabel() {
        birthLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(birthLabel)
        NSLayoutConstraint.activate([
            birthLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            birthLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            birthLabel.widthAnchor.constraint(equalToConstant: 50),
            birthLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
