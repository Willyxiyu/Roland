//
//  SettingPageTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/11/17.
//

import UIKit

class SettingPageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSettingItemsLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var settingItemsLabel: UILabel = {
        let settingItemsLabel = UILabel()
        settingItemsLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        settingItemsLabel.textAlignment = .left
        settingItemsLabel.textColor = .black
        return settingItemsLabel
    }()
    
    private func setupSettingItemsLabel() {
        settingItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(settingItemsLabel)
        NSLayoutConstraint.activate([
            settingItemsLabel.heightAnchor.constraint(equalToConstant: 20),
            settingItemsLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            settingItemsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            settingItemsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            settingItemsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
}
