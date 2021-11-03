//
//  GEPrivateCommentCell.swift
//  Roland
//
//  Created by 林希語 on 2021/11/4.
//

import Foundation
import UIKit

class GEPrivateCommentCell: UITableViewCell {
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserPhotoImageView()
        setupUserNameLabel()
        setupDateLabel()
        setupMessageLabel()
        setupThumbsupButton()
        setupEllipsisButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var userPhotoImageView: UIImageView = {
        let photoImage = UIImage(named: "photo")
        let userPhotoImageView = UIImageView()
        userPhotoImageView.image = photoImage
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.clipsToBounds = true
        return userPhotoImageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = UIColor.black
        userNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        userNameLabel.textAlignment = .left
        userNameLabel.text = "Willy Boy"
        return userNameLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor.black
        dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        dateLabel.textAlignment = .right
        dateLabel.text = "2021.11.03"
        return dateLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = UIColor.black
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        return messageLabel
    }()
    
    lazy var thumbsupButton: UIButton = {
        let thumbsupButton = UIButton()
        thumbsupButton.setImage(UIImage.init(systemName: "hand.thumbsup.fill"), for: .normal)
        thumbsupButton.layer.masksToBounds = true
        thumbsupButton.tintColor = .blue
        thumbsupButton.addTarget(self, action: #selector(thumbsup), for: .touchUpInside)
        return thumbsupButton
    }()
    
    @objc func thumbsup() {
        
    }
    
    lazy var ellipsisButton: UIButton = {
        let ellipsisButton = UIButton()
        ellipsisButton.setImage(UIImage.init(systemName: "ellipsis"), for: .normal)
        ellipsisButton.transform = ellipsisButton.transform.rotated(by: .pi / 2)
        ellipsisButton.layer.masksToBounds = true
        ellipsisButton.tintColor = .lightGray
        ellipsisButton.addTarget(self, action: #selector(ellipsis), for: .touchUpInside)
        return ellipsisButton
    }()
    
    @objc func ellipsis() {
        
    }
    
    private func setupUserPhotoImageView () {
        userPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userPhotoImageView)
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            userPhotoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1),
            userPhotoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupUserNameLabel () {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userPhotoImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            userNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupDateLabel () {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            dateLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupMessageLabel () {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupThumbsupButton () {
        thumbsupButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(thumbsupButton)
        NSLayoutConstraint.activate([
            thumbsupButton.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            thumbsupButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            thumbsupButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            thumbsupButton.heightAnchor.constraint(equalToConstant: 20),
            thumbsupButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupEllipsisButton () {
        ellipsisButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(ellipsisButton)
        NSLayoutConstraint.activate([
            ellipsisButton.centerYAnchor.constraint(equalTo: thumbsupButton.centerYAnchor),
            ellipsisButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            ellipsisButton.heightAnchor.constraint(equalToConstant: 20),
            ellipsisButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}

