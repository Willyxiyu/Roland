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
        setupEventHostPhoto()
        setupEventDateLabel()
        setupEventLocationLabel()
        setupEventTitleLabel()
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
    
    lazy var eventTitleLabel: UILabel = {
        let eventTitleLabel = UILabel()
        eventTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        eventTitleLabel.textColor = UIColor.white
        eventTitleLabel.textAlignment = .left
        eventTitleLabel.lineBreakMode = .byWordWrapping
        eventTitleLabel.numberOfLines = 0
        
        return eventTitleLabel
    }()
    
    lazy var eventLocationLabel: UILabel = {
        let eventLocationLabel = UILabel()
        eventLocationLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        eventLocationLabel.textColor = UIColor.white
        eventLocationLabel.textAlignment = .left
        eventLocationLabel.lineBreakMode = .byWordWrapping
        eventLocationLabel.numberOfLines = 0
        eventLocationLabel.text = "台北市信義區"
        return eventLocationLabel
    }()
    lazy var eventDateLabel: UILabel = {
        let eventDateLabel = UILabel()
        eventDateLabel.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        eventDateLabel.textColor = UIColor.white
        eventDateLabel.textAlignment = .left
        eventDateLabel.lineBreakMode = .byWordWrapping
        eventDateLabel.numberOfLines = 0
        eventDateLabel.text = "2021.10.31"
        return eventDateLabel
    }()
    
    lazy var eventViewsImageView: UIImageView = {
        let eventViewsImageView = UIImageView()
        eventViewsImageView.contentMode = .scaleAspectFill
        eventViewsImageView.image = UIImage.init(systemName: "eye.fill")
        eventViewsImageView.layer.borderWidth = 1
        eventViewsImageView.layer.borderColor = UIColor.white.cgColor
        eventViewsImageView.layer.cornerRadius = 15
        eventViewsImageView.clipsToBounds = true
        eventViewsImageView.tintColor = .white
        return eventViewsImageView
    }()
    
    private func setupEventPhoto() {
        eventPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventPhoto)
        NSLayoutConstraint.activate([
            eventPhoto.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            eventPhoto.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            eventPhoto.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            eventPhoto.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
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
    
    private func setupEventTitleLabel() {
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventTitleLabel)
        NSLayoutConstraint.activate([
            eventTitleLabel.leadingAnchor.constraint(equalTo: eventLocationLabel.leadingAnchor),
            eventTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            eventTitleLabel.bottomAnchor.constraint(equalTo: eventLocationLabel.topAnchor)
        ])
    }
    
    private func setupEventLocationLabel() {
        eventLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventLocationLabel)
        NSLayoutConstraint.activate([
            eventLocationLabel.leadingAnchor.constraint(equalTo: eventDateLabel.leadingAnchor),
            eventLocationLabel.bottomAnchor.constraint(equalTo: eventDateLabel.topAnchor)
        ])
    }
    private func setupEventDateLabel() {
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventDateLabel)
        NSLayoutConstraint.activate([
            eventDateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            eventDateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }
    
    private func setupEventViewsImageView() {
        eventViewsImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventViewsImageView)
        NSLayoutConstraint.activate([
            eventViewsImageView.centerYAnchor.constraint(equalTo: eventHostPhoto.centerYAnchor),
            eventViewsImageView.trailingAnchor.constraint(equalTo: eventPhoto.trailingAnchor, constant: -15)
        ])
    }
    
}
