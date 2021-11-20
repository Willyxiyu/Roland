//
//  CommentViewforFooterView.swift
//  Roland
//
//  Created by 林希語 on 2021/11/3.
//

import Foundation
import UIKit

class PublicCommentFooterView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    static let reuseIdentifier: String = String(describing: PublicCommentFooterView.self)
    
    var sendText: ((String) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUserPhotoImageView()
        setupCommentTextField()
        setupSendButton()
        commentTextField.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhotoImageView.layer.cornerRadius = UIScreen.main.bounds.width * 0.1 * 0.5
    }
    lazy var userPhotoImageView: UIImageView = {
//        let photoImage = UIImage(named: "photo")
        let userPhotoImageView = UIImageView()
//        userPhotoImageView.image = photoImage
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.clipsToBounds = true
        return userPhotoImageView
    }()
    
    lazy var commentTextField: UITextField = {
        
        let commentTextField = UITextField()
        commentTextField.setLeftPaddingPoints(10)
        commentTextField.backgroundColor = UIColor.clear
        commentTextField.placeholder = "新增公開留言"
        return commentTextField
    }()
    lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        sendButton.isEnabled = true
        sendButton.addTarget(self, action: #selector(sendTexttoMessage), for: .touchUpInside)
        sendButton.isEnabled = false
        return sendButton
    }()
    
    @objc func sendTexttoMessage() {
        
        if let text = commentTextField.text {
            
            sendText?(text)
        }
        
        commentTextField.text?.removeAll()
        sendButton.isEnabled = false
        sendButton.setTitleColor(.gray, for: .normal)
        
    }
    
    private func setupUserPhotoImageView () {
        userPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userPhotoImageView)
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            userPhotoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            userPhotoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            userPhotoImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1),
            userPhotoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupCommentTextField() {
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(commentTextField)
        NSLayoutConstraint.activate([
            commentTextField.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 15),
            commentTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50),
            commentTextField.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1)
        ])
        commentTextField.delegate = self
    }
    
    private func setupSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func textFieldDidEndEditing(_ commentTextField: UITextField) {
        
        if commentTextField.text?.isEmpty == true {
            
            sendButton.isEnabled = false
            sendButton.setTitleColor(.gray, for: .normal)
            
        } else if commentTextField.text?.isEmpty == false {
            
            sendButton.isEnabled = true
            sendButton.setTitleColor(.link, for: .normal)
        }
    }
    
    func textFieldDidBeginEditing(_ commentTextField: UITextField) {
        
        sendButton.isEnabled = false
        sendButton.setTitleColor(.gray, for: .normal)
        
    }
    
}
