//
//  NotificationTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/11/2.
//

import Foundation
import UIKit

class NTFNewRequestCell: UITableViewCell {
    
    var deleteCellRowNumberForClosure: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserImageView()
        setupUserNameLabel()
        setupIntroLabel()
        setupAcceptedButton()
        setupRejectedButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = UIScreen.main.bounds.width * 0.15 * 0.5
        
    }
    
    lazy var userImageView: UIImageView = {
        
        let userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
        return userImageView
    }()
    
    lazy var userNameLabel: UILabel = {
        
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        userNameLabel.textColor = UIColor.black
        userNameLabel.textAlignment = .left
        
        return userNameLabel
    }()
    
    lazy var introLabel: UILabel = {
        
        let introLabel = UILabel()
        introLabel.numberOfLines = 0
        introLabel.textAlignment = .left
        introLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        introLabel.text = "想參加您的\n聖誕活動喔！～"
        return introLabel
    }()
    
    lazy var acceptedButton: UIButton = {
        let acceptedButton = UIButton()
        acceptedButton.setTitle("允許加入", for: .normal)
        acceptedButton.layer.cornerRadius = 5
        acceptedButton.layer.borderWidth = 1.5
        acceptedButton.setTitleColor(UIColor.black, for: .normal)
        acceptedButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        acceptedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        acceptedButton.isEnabled = true
        return acceptedButton
    }()
    lazy var rejectedButton: UIButton = {
        let rejectedButton = UIButton()
        rejectedButton.setTitle("否決加入", for: .normal)
        rejectedButton.layer.cornerRadius = 5
        rejectedButton.backgroundColor = UIColor.themeColor
        rejectedButton.setTitleColor(UIColor.white, for: .normal)
        rejectedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        rejectedButton.isEnabled = true
        return rejectedButton
    }()
    
    private func setupUserImageView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            userImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            userImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15),
            userImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15)
        ])
    }
    
    private func setupUserNameLabel () {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20)
        ])
    }
    
    private func setupIntroLabel() {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(introLabel)
        NSLayoutConstraint.activate([
            introLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            introLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            introLabel.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -10),
            introLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
        
    }
    
    private func setupAcceptedButton() {
        acceptedButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(acceptedButton)
        NSLayoutConstraint.activate([
            acceptedButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            acceptedButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2),
            acceptedButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3)
        ])
    }
    private func setupRejectedButton() {
        rejectedButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(rejectedButton)
        NSLayoutConstraint.activate([
            rejectedButton.leadingAnchor.constraint(equalTo: acceptedButton.trailingAnchor, constant: 15),
            rejectedButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            rejectedButton.centerYAnchor.constraint(equalTo: acceptedButton.centerYAnchor),
            rejectedButton.widthAnchor.constraint(equalTo: acceptedButton.widthAnchor),
            rejectedButton.heightAnchor.constraint(equalTo: acceptedButton.heightAnchor)
        ])
    }
}

class NTFNewMessageCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
