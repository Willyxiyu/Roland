//
//  GroupEventCollectionViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

class GroupEventCollectionViewCell: UICollectionViewCell {

    static let identifier = "GroupEventCollectionViewCell"
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEventPhoto()
        setupEventDateLabel()
        setupEventTitleLabel()
//        setupEventLocationLabel()
        setupEventViewsImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var eventPhoto: UIImageView = {
        let eventPhoto = UIImageView()
        eventPhoto.contentMode = .scaleAspectFill
        eventPhoto.image = UIImage(named: "GroupPhoto")
        eventPhoto.layer.cornerRadius = 15
        eventPhoto.clipsToBounds = true
        eventPhoto.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return eventPhoto
    }()
    
    lazy var eventHostPhoto: UIImageView = {
        let eventHostPhoto = UIImageView()
        eventHostPhoto.contentMode = .scaleAspectFill
        eventHostPhoto.image = UIImage(named: "photo")
        eventHostPhoto.layer.borderWidth = 1
        eventHostPhoto.layer.borderColor = UIColor.white.cgColor
        eventHostPhoto.layer.cornerRadius = 15
        eventHostPhoto.clipsToBounds = true
        return eventHostPhoto
    }()
    
    lazy var eventDateLabel: UILabel = {
        let eventDateLabel = UILabel()
        eventDateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        eventDateLabel.textColor = UIColor.hexStringToUIColor(hex: "a5a58d")
        eventDateLabel.textAlignment = .left
        eventDateLabel.lineBreakMode = .byWordWrapping
        eventDateLabel.numberOfLines = 2
        return eventDateLabel
    }()
    
    lazy var eventTitleLabel: UILabel = {
        let eventTitleLabel = UILabel()
        eventTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        eventTitleLabel.textColor = UIColor.black
        eventTitleLabel.textAlignment = .left
        eventTitleLabel.lineBreakMode = .byWordWrapping
        eventTitleLabel.numberOfLines = 0
        
        return eventTitleLabel
    }()
    
    lazy var eventLocationLabel: UILabel = {
        let eventLocationLabel = UILabel()
        eventLocationLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        eventLocationLabel.textColor = UIColor.black
        eventLocationLabel.textAlignment = .left
        eventLocationLabel.lineBreakMode = .byWordWrapping
        eventLocationLabel.numberOfLines = 0
//        eventLocationLabel.text = "台北市信義區"
        return eventLocationLabel
    }()
  
    lazy var eventViewsImageView: UIImageView = {
        let eventViewsImageView = UIImageView()
        eventViewsImageView.contentMode = .scaleAspectFill
        eventViewsImageView.image = UIImage.init(systemName: "eye.fill")
        eventViewsImageView.tintColor = .white
        return eventViewsImageView
    }()
    
    lazy var ellipsisButton: UIButton = {
        let ellipsisButton = UIButton()
        ellipsisButton.setImage(UIImage.init(systemName: "ellipsis"), for: .normal)
        ellipsisButton.transform = ellipsisButton.transform.rotated(by: .pi / 2)
        ellipsisButton.layer.masksToBounds = true
        ellipsisButton.tintColor = .lightGray
//        ellipsisButton.addTarget(self, action: #selector(ellipsis), for: .touchUpInside)
        return ellipsisButton
    }()
    
//    @objc func ellipsis() {
//
//        let alert = UIAlertController(title: "檢舉", message: "您的檢舉將會匿名，如果有人有立即的人身安全疑慮，請立即與當地緊急救護服務連絡，把握救援時間！檢舉內容：仇恨言論、符號、垃圾訊息、霸凌或騷擾、自殺或自殘、誤導或詐騙....等等", preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//
//        let confirm = UIAlertAction(title: "確認檢舉", style: .default, handler: { [weak self] _ in
//
//            guard let self = self else { return }
//
//            guard let eventId = self.selectedEventId else {
//                return
//            }
//
//            FirebaseManger.shared.postGroupEventIdtoSelfBlockList(groupEventId: eventId)
//
//        })
//
//        alert.addAction(cancel)
//
//        alert.addAction(confirm)
//
//        self.present(alert, animated: true, completion: nil)
//
//    }
//
    private func setupEventPhoto() {
        eventPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventPhoto)
        NSLayoutConstraint.activate([
            eventPhoto.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            eventPhoto.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            eventPhoto.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            eventPhoto.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupEventDateLabel() {
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventDateLabel)
        NSLayoutConstraint.activate([
            eventDateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            eventDateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            eventDateLabel.topAnchor.constraint(equalTo: eventPhoto.bottomAnchor, constant: 10),
            eventDateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupEventTitleLabel() {
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventTitleLabel)
        NSLayoutConstraint.activate([
            eventTitleLabel.leadingAnchor.constraint(equalTo: eventDateLabel.leadingAnchor),
            eventTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            eventTitleLabel.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: 10),
            eventTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            eventTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupEventLocationLabel() {
        eventLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventLocationLabel)
        NSLayoutConstraint.activate([
            eventLocationLabel.leadingAnchor.constraint(equalTo: eventDateLabel.leadingAnchor),
            eventLocationLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 10),
            eventLocationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            eventLocationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupEventHostPhoto() {
        eventHostPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventHostPhoto)
        NSLayoutConstraint.activate([
            eventHostPhoto.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            eventHostPhoto.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            eventHostPhoto.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3),
            eventHostPhoto.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
        ])
    }

    private func setupEventViewsImageView() {
        ellipsisButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(ellipsisButton)
        NSLayoutConstraint.activate([
            ellipsisButton.topAnchor.constraint(equalTo: eventDateLabel.topAnchor),
            ellipsisButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
    
}
