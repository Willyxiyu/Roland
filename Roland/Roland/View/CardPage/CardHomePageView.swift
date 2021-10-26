//
//  CardView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
//

import UIKit
// 臨時按鍵，之後不需要
class CardHomePageView: UIView {
    // MARK: - UIProperties
    lazy var rolandLabel: UILabel = {
        let rolandLabel = UILabel()
        rolandLabel.textColor = UIColor.themeColor
        rolandLabel.font = UIFont.medium(size: 20)
        rolandLabel.text = "Roland"
        return rolandLabel
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
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setupRolandLabel()
        setupAddUserInfoButton()
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
    private func setupAddUserInfoButton() {
        addUserInfoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addUserInfoButton)
        NSLayoutConstraint.activate([
            addUserInfoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addUserInfoButton.centerYAnchor.constraint(equalTo: rolandLabel.centerYAnchor)
        ])
    }
}
