//
//  GroupEventCEPFEPVCTVCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

class GroupEventCEPFEPVCTVCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
// MARK: - PhotoCell
class GEPhotoCell: UITableViewCell {
    
    var addNewPhoto: (() -> Void)?
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPhotoImageView()
        setupEventImageButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    lazy var eventImageButton: UIButton = {
        let eventImageButton = UIButton()
        eventImageButton.setImage(UIImage.init(systemName: "photo.artframe"), for: .normal)
        eventImageButton.backgroundColor = UIColor.lightGray
        eventImageButton.layer.masksToBounds = true
        eventImageButton.tintColor = .black
        eventImageButton.addTarget(self, action: #selector(eventImageButtonTapped), for: .touchUpInside)
        return eventImageButton
    }()
    
    @objc func eventImageButtonTapped() {
        print("YEEEEE")
        addNewPhoto?()
        
    }
    private func setupPhotoImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 3 / 4)
        ])
    }
    
    private func setupEventImageButton() {
        eventImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventImageButton)
        NSLayoutConstraint.activate([
            eventImageButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            eventImageButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
    
}
// MARK: - TitleCell

class GETitleCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
}

// MARK: - DetailCell
class GEDetailCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupEDTLabel()
        setupEDLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var eventDetailTitleLabel: UILabel = {
        let eventDetailTitleLabel = UILabel()
        eventDetailTitleLabel.textColor = UIColor.black
        eventDetailTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        eventDetailTitleLabel.textAlignment = .left
        return eventDetailTitleLabel
    }()
    
    lazy var eventDetailLabel: UILabel = {
        let eventDetailLabel = UILabel()
        eventDetailLabel.textColor = UIColor.black
        eventDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        eventDetailLabel.textAlignment = .right
        return eventDetailLabel
    }()
    
    private func setupEDTLabel() {
        eventDetailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventDetailTitleLabel)
        NSLayoutConstraint.activate([
            eventDetailTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            eventDetailTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            eventDetailTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    private func setupEDLabel() {
        eventDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventDetailLabel)
        NSLayoutConstraint.activate([
            eventDetailLabel.centerYAnchor.constraint(equalTo: eventDetailTitleLabel.centerYAnchor),
            eventDetailLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - IntroCell
class GEIntroCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupEventIntroTitleLabel()
        setupEventIntroLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var eventIntroTitleLabel: UILabel = {
        let eventIntroTitleLabel = UILabel()
        eventIntroTitleLabel.textColor = UIColor.black
        eventIntroTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        eventIntroTitleLabel.textAlignment = .left
        return eventIntroTitleLabel
    }()
    
    lazy var eventIntroLabel: UILabel = {
        let eventIntroLabel = UILabel()
        eventIntroLabel.textColor = UIColor.black
        eventIntroLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        eventIntroLabel.textAlignment = .left
        eventIntroLabel.lineBreakMode = .byWordWrapping
        eventIntroLabel.numberOfLines = 0
        return eventIntroLabel
    }()
    
    private func setupEventIntroTitleLabel() {
        eventIntroTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventIntroTitleLabel)
        NSLayoutConstraint.activate([
            eventIntroTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            eventIntroTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupEventIntroLabel() {
        eventIntroLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventIntroLabel)
        NSLayoutConstraint.activate([
            eventIntroLabel.topAnchor.constraint(equalTo: eventIntroTitleLabel.bottomAnchor, constant: 2),
            eventIntroLabel.leadingAnchor.constraint(equalTo: eventIntroTitleLabel.leadingAnchor),
            eventIntroLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            eventIntroLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
// MARK: - MessageCell
class GEMessageCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMSgControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    lazy var messageSegmentedControl: UISegmentedControl = {
        let messageSegmentedControl = UISegmentedControl(items: ["公開留言板", "團員留言板", "影音區"])
        messageSegmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
        messageSegmentedControl.tintColor = UIColor.themeColor
        messageSegmentedControl.backgroundColor = UIColor.themeColor
        messageSegmentedControl.selectedSegmentIndex = 0
        return messageSegmentedControl
    }()

    private func setupMSgControl() {
        messageSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageSegmentedControl)
        NSLayoutConstraint.activate([
            messageSegmentedControl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            messageSegmentedControl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            messageSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            messageSegmentedControl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -100)
        
        ])
    }
}
