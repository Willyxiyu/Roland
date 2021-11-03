//
//  GroupEventCEPFEPVCTVCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

class GEDetailPageTitleCell: UITableViewCell {
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
//        setupCancelButton()
//        setupEditButton()
//        setupShareEventButton()
//        setupRegisButton()
//        setupCancelRegisButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消活動", for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cancelButton.isEnabled = true
        return cancelButton
    }()
    lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.setTitle("編輯活動", for: .normal)
        editButton.layer.cornerRadius = 10
        editButton.backgroundColor = UIColor.themeColor
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        editButton.isEnabled = true
        return editButton
    }()
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -10),
            cancelButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25),
            cancelButton.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            editButton.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 10),
            editButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25),
            editButton.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07)
        ])
    }
    
    lazy var shareEventButton: UIButton = {
        let shareEventButton = UIButton()
        shareEventButton.setTitle("分享活動", for: .normal)
        shareEventButton.layer.cornerRadius = 10
        shareEventButton.layer.borderWidth = 1
        shareEventButton.setTitleColor(UIColor.black, for: .normal)
        shareEventButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        shareEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        shareEventButton.isEnabled = true
        return shareEventButton
    }()
    lazy var regisButton: UIButton = {
        let regisButton = UIButton()
        regisButton.setTitle("報名活動", for: .normal)
        regisButton.layer.cornerRadius = 10
        regisButton.backgroundColor = UIColor.themeColor
        regisButton.setTitleColor(UIColor.white, for: .normal)
        regisButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        regisButton.isEnabled = true
        return regisButton
    }()
    
    lazy var cancelRegisButton: UIButton = {
        let cancelRegisButton = UIButton()
        cancelRegisButton.setTitle("取消報名", for: .normal)
        cancelRegisButton.layer.cornerRadius = 10
        cancelRegisButton.layer.borderWidth = 1
        cancelRegisButton.setTitleColor(UIColor.black, for: .normal)
        cancelRegisButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        cancelRegisButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cancelRegisButton.isEnabled = true
        return cancelRegisButton
    }()
    
    private func setupRegisButton() {
        regisButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(regisButton)
        NSLayoutConstraint.activate([
            regisButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            regisButton.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -10),
            regisButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            regisButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25),
            regisButton.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupCancelRegisButton() {
        cancelRegisButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cancelRegisButton)
        NSLayoutConstraint.activate([
            cancelRegisButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            cancelRegisButton.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -10),
            cancelRegisButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            cancelRegisButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25),
            cancelRegisButton.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupShareEventButton() {
        shareEventButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(shareEventButton)
        NSLayoutConstraint.activate([
            shareEventButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            shareEventButton.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 10),
            shareEventButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25),
            shareEventButton.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07)
        ])
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
            photoImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 9 / 16)
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
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
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
        eventDetailTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
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
            eventDetailTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }
    private func setupEDLabel() {
        eventDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventDetailLabel)
        NSLayoutConstraint.activate([
            eventDetailLabel.leadingAnchor.constraint(equalTo: eventDetailTitleLabel.leadingAnchor),
            eventDetailLabel.topAnchor.constraint(equalTo: eventDetailTitleLabel.bottomAnchor, constant: 2),
            eventDetailLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
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
        eventIntroTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        eventIntroTitleLabel.textAlignment = .left
        eventIntroTitleLabel.text = "關於"
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: -9, left: 0, bottom: -9, right: 0))
//    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCommentLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    lazy var commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        commentLabel.textAlignment = .left
        return commentLabel
    }()

    private func setupCommentLabel() {
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(commentLabel)
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            commentLabel.heightAnchor.constraint(equalToConstant: 30),
            commentLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            commentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        
        ])
    }
}

// MARK: - DateCell
class GEDateCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupIconImageView()
        setupDateLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage.init(systemName: "calendar")
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return dateLabel
    }()

    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            iconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30)
        
        ])
    }
}

// MARK: - DateCell
class GElocationCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupIconImageView()
        setuplocationLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage.init(systemName: "location.circle")
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return locationLabel
    }()

    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            iconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    private func setuplocationLabel() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            locationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30)
        
        ])
    }
    
}

// MARK: - DateCell
class GEHostandAttendeesCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLable()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return titleLabel
    }()
    
    private func setupTitleLable() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -50)
        ])
    }
}
