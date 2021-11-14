//
//  ChatroomListTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/24.
//

import UIKit

class ChatroomListTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserImageView()
        setUpUserNameLabel()
        setupUserMessageLabel()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = UIScreen.main.bounds.width * 0.15 * 0.5
        
    }
    
    // MARK: - Properties
    
    lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        return userImageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        userNameLabel.textColor = UIColor.black
        userNameLabel.textAlignment = .left
        return userNameLabel
    }()
    
    lazy var userMessageLabel: UILabel = {
        let userMessageLabel = UILabel()
        userMessageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        userMessageLabel.textColor = UIColor.black
        userMessageLabel.textAlignment = .left
        return userMessageLabel
    }()
    
    func setupUserImageView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            userImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            userImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15),
            userImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15)
        ])
    }
    
    func setUpUserNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20)
        ])
    }
    
    func setupUserMessageLabel() {
        userMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userMessageLabel)
        NSLayoutConstraint.activate([
            userMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            userMessageLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor)
        ])
    }
}
