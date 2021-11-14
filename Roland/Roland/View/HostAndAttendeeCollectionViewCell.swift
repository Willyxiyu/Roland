//
//  HostAndAttendeeCollectionViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/11/14.
//

import UIKit

class HostAndAttendeeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HostAndAttendeeCollectionViewCell"
    
//    weak var delegate: HostAndAttendeePhotoDelegate?
//
//    var photo: HostAndAttendeeCell = .hostCell
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEventHostPhoto()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hostAndAttendeePhoto.layer.cornerRadius = ((UIScreen.width) - 60 ) / 10
    }
    
    lazy var hostAndAttendeePhoto: UIImageView = {
        let hostAndAttendeePhoto = UIImageView()
        hostAndAttendeePhoto.contentMode = .scaleAspectFill
//        hostAndAttendeePhoto.image = UIImage(named: "photo")
        hostAndAttendeePhoto.clipsToBounds = true
        return hostAndAttendeePhoto
    }()
    
    private func setupEventHostPhoto() {
        hostAndAttendeePhoto.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(hostAndAttendeePhoto)
        NSLayoutConstraint.activate([
            hostAndAttendeePhoto.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            hostAndAttendeePhoto.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            hostAndAttendeePhoto.heightAnchor.constraint(equalTo: self.contentView.widthAnchor),
            hostAndAttendeePhoto.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        ])
    }
}
