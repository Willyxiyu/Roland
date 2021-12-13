//
//  CardView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/22.
//

import UIKit
import Kingfisher

protocol SlingCardUserIdDelegate: AnyObject {
    
    func sendingUserIdFromLeft(_ userId: String)
    
    func sendingUserIdFromRight(_ userId: String)

}

class CardView: UIView {

    // MARK: - UIViews
    // later update will add residenceLabel and introductionLabel to complete the info of card.
    private let cardImageView = CardImageView()
    private let gradientLayer = CAGradientLayer()
    private let nameLabel = CardInfoLabel(labelFont: .medium(size: 40))
    private let ageLabel = CardInfoLabel(labelFont: .medium(size: 40))
    private let genderLabel = CardInfoLabel(labelFont: .medium(size: 30))
    private let introLabel = CardInfoLabel(labelFont: .medium(size: 15))
    private var otherUserId: String?
    private lazy var cardIconImage: UIImageView = {
        let cardIconImage = UIImageView()
        cardIconImage.image = UIImage(named: "heart")
        cardIconImage.alpha = 0
        return cardIconImage
    }()
    
    weak var delegate: SlingCardUserIdDelegate?
    
    init(user: UserInfo) {
        super.init(frame: .zero)
        setupCardImageView(user: user)
        setupGradientLayer()
        setupCardIconImage(user: user)
        setupNameLabel(user: user)
        setupAgeLabel(user: user)
        setupGenderLabel(user: user)
        setupIntroLabel(user: user)
        otherUserId = user.userId
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCardView))
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        
    }
    
    @objc func panCardView(gesture: UIPanGestureRecognizer) {
        
        guard let view  = gesture.view else { return }
        
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            
            self.handlePanChange(translation: translation)
            
        } else if gesture.state == .ended {
            
            self.handlePanEnded(view: view, translation: translation)
        }
    }
    
    func handlePanChange(translation: CGPoint) {
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 100
        
        let rotateTranslation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotateTranslation.translatedBy(x: translation.x, y: translation.y)
        
        let ratio: CGFloat = 1 / 100
        let ratioValue = ratio * translation.x
        
        if translation.x > 0 {
            self.cardIconImage.alpha = ratioValue
            self.cardIconImage.image = UIImage(named: "heart")
            
        } else if translation.x < 0 {
            self.cardIconImage.alpha = -ratioValue
            self.cardIconImage.image = UIImage(named: "no-entry")
            
        }
    }
    
    func handlePanEnded(view: UIView, translation: CGPoint) {
        
        if translation.x <= -120 {  // sliding left
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
                let degree: CGFloat = -600 / 40
                let angle = degree * .pi / 180
                
                let rotateTranslation = CGAffineTransform(rotationAngle: angle)
                view.transform = rotateTranslation.translatedBy(x: -600, y: 100)
                self.layoutIfNeeded()
                
            } completion: { _ in
                
                // sliding left adding other's id to self dislikeList and remove the card form the screen
              
                if let userId = self.otherUserId {
                    
                    self.delegate?.sendingUserIdFromLeft(userId)
                                        
                    self.removeFromSuperview()

                }
                
            }
        } else if translation.x >= 120 {  // sliding right
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
                let degree: CGFloat = 600 / 40
                let angle = degree * .pi / 180
                
                let rotateTranslation = CGAffineTransform(rotationAngle: angle)
                view.transform = rotateTranslation.translatedBy(x: 600, y: 100)
                self.layoutIfNeeded()
                
            } completion: { _ in
                
                guard let userId = self.otherUserId else {
                    return
                }
                
                self.delegate?.sendingUserIdFromRight(userId)
                // sliding right adding other's id in self likeList and remove the card form the screen
                self.removeFromSuperview()
                
            }
            
        } else {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
                self.transform = .identity
                self.layoutIfNeeded()
                self.cardIconImage.alpha = 0
            }
        }
    }
    private func setupCardImageView(user: UserInfo) {
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardImageView)
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: self.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        if let photo = user.photo {
            
            cardImageView.kf.setImage(with: URL(string: photo))
            
        }
        
    }
    private func setupCardIconImage(user: UserInfo) {
        cardIconImage.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(cardIconImage)
        NSLayoutConstraint.activate([
            cardIconImage.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor),
            cardIconImage.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor),
            cardIconImage.widthAnchor.constraint(equalTo: cardImageView.widthAnchor, multiplier: 0.3),
            cardIconImage.heightAnchor.constraint(equalTo: cardImageView.widthAnchor, multiplier: 0.3)
        ])
    }
    private func setupNameLabel(user: UserInfo) {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -150)
        ])
        nameLabel.text = user.name
    }
    private func setupAgeLabel(user: UserInfo) {
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10)
        ])
        ageLabel.text = user.age
    }
    
    private func setupGenderLabel(user: UserInfo) {
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(genderLabel)
        NSLayoutConstraint.activate([
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
        ])
        genderLabel.text = user.gender
    }
    
    private func setupIntroLabel(user: UserInfo) {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(introLabel)
        NSLayoutConstraint.activate([
            introLabel.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor),
            introLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor),
            introLabel.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: -10)
        ])
        introLabel.text = user.intro
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        cardImageView.layer.addSublayer(gradientLayer)
    }
}
