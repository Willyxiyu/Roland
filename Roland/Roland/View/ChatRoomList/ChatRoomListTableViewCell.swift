//
//  ChatRoomTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/19.
//

import UIKit

// MARK: - TableViewCellDelegate

// protocol TableViewCellDelegate: AnyObject {
//    func deleteSelectedCell(_ cell: UITableViewCell, tag: Int)
// }
// MARK: - UITableViewCell
class ChatRoomListTableViewCell: UITableViewCell {
    //    weak var delegate: TableViewCellDelegate?
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserPicImageView()
        setupUserNameLabel()
    }
    required init?(coder: NSCoder) { super.init(coder: coder)
    }
    // MARK: - Properties
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.medium(size: 18)
        userNameLabel.textAlignment = .left
        return userNameLabel
    }()
    lazy var userPicImageView: UIImageView = {
        let userPicImageView = UIImageView()
        userPicImageView.translatesAutoresizingMaskIntoConstraints = false
        userPicImageView.clipsToBounds = true
        userPicImageView.layer.cornerRadius = self.bounds.height / 2
        userPicImageView.contentMode = .scaleAspectFill
        userPicImageView.image = UIImage(named: "PS5")
        userPicImageView.layer.borderWidth = 2
        userPicImageView.layer.borderColor = UIColor.secondThemeColor?.cgColor
        return userPicImageView
    }()
    func setupUserPicImageView() {
        contentView.addSubview(userPicImageView)
        NSLayoutConstraint.activate([
            userPicImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            userPicImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            userPicImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            userPicImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            userPicImageView.heightAnchor.constraint(equalToConstant: 50),
            userPicImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userPicImageView.trailingAnchor, constant: 5),
            userNameLabel.widthAnchor.constraint(equalToConstant: 100),
            userNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
