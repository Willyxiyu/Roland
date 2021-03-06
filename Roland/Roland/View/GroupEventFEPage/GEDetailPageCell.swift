//
//  GroupEventCEPFEPVCTVCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

import Kingfisher

import FirebaseFirestore

class GEDetailPageTitleCell: UITableViewCell {
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        selectionStyle = .none
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
}
// MARK: - PhotoCell
class GEPhotoCell: UITableViewCell {
    
    var addNewPhoto: (() -> Void)?
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPhotoImageView()
        setupButtonBackView()
        setupEventImageButton()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonBackView.layer.cornerRadius = UIScreen.main.bounds.width * 0.2 * 0.5
    }
    
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    lazy var buttonBackView: UIView = {
        let buttonBackView = UIView()
        buttonBackView.backgroundColor = .white
        buttonBackView.alpha = 0.5
        buttonBackView.clipsToBounds = true
        return buttonBackView
    }()
    
    lazy var eventImageButton: UIButton = {
        
        let eventImageButton = UIButton()
        let origImage = UIImage(named: "addpicture")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        eventImageButton.setImage(tintedImage, for: .normal)
        eventImageButton.tintColor = .themeColor
        eventImageButton.layer.masksToBounds = true
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
    private func setupButtonBackView() {
        buttonBackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(buttonBackView)
        NSLayoutConstraint.activate([
            buttonBackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            buttonBackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            buttonBackView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2),
            buttonBackView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupEventImageButton() {
        eventImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventImageButton)
        NSLayoutConstraint.activate([
            eventImageButton.centerXAnchor.constraint(equalTo: buttonBackView.centerXAnchor),
            eventImageButton.centerYAnchor.constraint(equalTo: buttonBackView.centerYAnchor),
            eventImageButton.heightAnchor.constraint(equalTo: buttonBackView.widthAnchor, multiplier: 0.8),
            eventImageButton.widthAnchor.constraint(equalTo: buttonBackView.widthAnchor, multiplier: 0.8)
        ])
    }
    
}
// MARK: - TitleCell

class GETitleCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        selectionStyle = .none
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
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var eventDetailTitleLabel: UILabel = {
        let eventDetailTitleLabel = UILabel()
        eventDetailTitleLabel.textColor = UIColor.black
        eventDetailTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        eventDetailTitleLabel.textAlignment = .left
        return eventDetailTitleLabel
    }()
    
    lazy var eventDetailLabel: UILabel = {
        let eventDetailLabel = UILabel()
        eventDetailLabel.textColor = UIColor.black
        eventDetailLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
            eventDetailLabel.topAnchor.constraint(equalTo: eventDetailTitleLabel.bottomAnchor, constant: 10),
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
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var eventIntroTitleLabel: UILabel = {
        let eventIntroTitleLabel = UILabel()
        eventIntroTitleLabel.textColor = UIColor.black
        eventIntroTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        eventIntroTitleLabel.textAlignment = .left
        eventIntroTitleLabel.text = "關於"
        return eventIntroTitleLabel
    }()
    
    lazy var eventIntroLabel: UILabel = {
        let eventIntroLabel = UILabel()
        eventIntroLabel.textColor = UIColor.black
        eventIntroLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
            eventIntroLabel.topAnchor.constraint(equalTo: eventIntroTitleLabel.bottomAnchor, constant: 10),
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
        setupCommentLabel()
        selectionStyle = .none
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
        selectionStyle = .none
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
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dateLabel.numberOfLines = 0
        dateLabel.lineBreakMode = .byWordWrapping
        return dateLabel
    }()
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            iconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
            dateLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        ])
    }
}

// MARK: - LocationCell
class GElocationCell: UITableViewCell {
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupIconImageView()
        setuplocationLabel()
        selectionStyle = .none
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
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return locationLabel
    }()
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    private func setuplocationLabel() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            locationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
            
        ])
    }
    
}
// MARK: - HostandAttendeesCell

class GEHostandAttendeesCell: UITableViewCell {
    
    var hostAndAttendeeCollectionView: UICollectionView!
    
    let layout = UICollectionViewFlowLayout()
    
    let dispatchGroup = DispatchGroup()
    
    var userInfo = [UserInfo]() {
        
        didSet {
            
            hostAndAttendeeCollectionView.reloadData()
        }
    }
    
    var userId: [String]? {
        
        didSet {
            
            self.userInfo.removeAll()
            
            guard let userIds = self.userId else {

                fatalError("error")
            }
            
            for userId in userIds {
                
                FirebaseManger.shared.fetchOtherUserInfo(otherUserId: userId) { result in

                    guard let result = result else {
                        
                        fatalError("error")
                    }

                    self.userInfo.append(result)
                }
            }
        }
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLable()
        
        configureCellSize()
        hostAndAttendeeCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        setupHostAndAttendeeCollectionView()
        hostAndAttendeeCollectionView.register(HostAndAttendeeCollectionViewCell.self, forCellWithReuseIdentifier: HostAndAttendeeCollectionViewCell.identifier)
        hostAndAttendeeCollectionView.dataSource = self
        hostAndAttendeeCollectionView.delegate = self
        hostAndAttendeeCollectionView.backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return titleLabel
    }()
    
    func configureCellSize() {
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: ((UIScreen.width) - 60 ) / 5, height: ((UIScreen.width) - 60 ) / 5)
    }
    
    private func setupHostAndAttendeeCollectionView() {
        hostAndAttendeeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(hostAndAttendeeCollectionView)
        NSLayoutConstraint.activate([
            hostAndAttendeeCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            hostAndAttendeeCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            hostAndAttendeeCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            hostAndAttendeeCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            hostAndAttendeeCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupTitleLable() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension GEHostandAttendeesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hostAndAttendeeCollectionView.dequeueReusableCell(withReuseIdentifier: HostAndAttendeeCollectionViewCell.identifier,
                                                                           for: indexPath) as? HostAndAttendeeCollectionViewCell else {
            fatalError("error")
        }
        
            if let photoString = self.userInfo[indexPath.row].photo {

                cell.hostAndAttendeePhoto.kf.setImage(with: URL(string: photoString))
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((UIScreen.width) - 60 ) / 5, height: ((UIScreen.width) - 60 ) / 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
