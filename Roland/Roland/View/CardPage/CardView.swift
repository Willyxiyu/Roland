//
//  CardView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/22.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseAuth

protocol CardInfoProtocol: AnyObject {
    
    func didDislikeUser(_ card: CardView)
    
    func didLikeUser(_ card: CardView)
}

class CardView: UIView {
    
    weak var delegate: CardInfoProtocol?
    
    // MARK: - UIViews
    private let cardImageView = CardImageView()
    private let gradientLayer = CAGradientLayer()
    private let nameLabel = CardInfoLabel(frame: .zero, labelText: "", labelFont: .systemFont(ofSize: 40, weight: .heavy))
    private let ageLabel = CardInfoLabel(frame: .zero, labelText: "", labelFont: .systemFont(ofSize: 40, weight: .heavy))
    private let residenceLabel = CardInfoLabel(frame: .zero, labelText: "", labelFont: .systemFont(ofSize: 15, weight: .regular))
     let userIdLabel = CardInfoLabel(frame: .zero, labelText: "", labelFont: .systemFont(ofSize: 20, weight: .regular))
    private let introductionLabel = CardInfoLabel(frame: .zero, labelText: "", labelFont: .systemFont(ofSize: 20, weight: .regular))
    private lazy var cardIconImage: UIImageView = {
        let cardIconImage = UIImageView()
        cardIconImage.image = UIImage(named: "heart")
        cardIconImage.alpha = 0
        return cardIconImage
    }()
    
    init(user: UserInfo) {
        super.init(frame: .zero)
        setupCardImageView(user: user)
        setupGradientLayer()
        setupCardIconImage(user: user)
        setupNameLabel(user: user)
        setupAgeLabel(user: user)
        setupResidenceLabel(user: user)
        setupUserIdLabel(user: user)
        setupIntroductionLabel(user: user)
        userIdLabel.alpha = 0
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCardView))
        self.addGestureRecognizer(panGesture)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
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
           
        if translation.x <= -120 {  // 左滑
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
                let degree: CGFloat = -600 / 40
                let angle = degree * .pi / 180
                
                let rotateTranslation = CGAffineTransform(rotationAngle: angle)
                view.transform = rotateTranslation.translatedBy(x: -600, y: 100)
                self.layoutIfNeeded()
                
            } completion: { _ in
                
//                左滑不喜歡，將對方的ID加入到自己的dislikeList
                
                guard let userId = self.userIdLabel.text else {
                    return
                }
                
                FirebaseManger.shared.postAccepterIdtoSelfDislikeList(accepterId: userId)
                
//                print("dislike")
                
                self.removeFromSuperview()
                
            }
        } else if translation.x >= 120 {  // 右滑
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
                let degree: CGFloat = 600 / 40
                let angle = degree * .pi / 180
                
                let rotateTranslation = CGAffineTransform(rotationAngle: angle)
                view.transform = rotateTranslation.translatedBy(x: 600, y: 100)
                self.layoutIfNeeded()
                
            } completion: { _ in
                
                guard let userId = self.userIdLabel.text else {
                    return
                }
                
                FirebaseManger.shared.fetchlikeListOfUserId(accepterId: userId) { result in
                    
                    if result.isEmpty == true {
                        
                        FirebaseManger.shared.postAccepterIdtoSelflikeList(accepterId: userId)
                        
                    } else {
                        
                        FirebaseManger.shared.postAccepterIdtoSelflikeList(accepterId: userId)
                        
                        let message = Message(sender: Sender(photoURL: "", senderId: "", displayName: ""), messageId: "", sentDate: Date(), kind: .text("Hi 很高興認識你"))
                        
                        FirebaseManger.shared.createNewChatRoom(accepterId: userId, firstMessage: message)
                        
                        print("建立聊天室")
                        
                    }
                }
                
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
    private func setupResidenceLabel(user: UserInfo) {
        residenceLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(residenceLabel)
        NSLayoutConstraint.activate([
            residenceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            residenceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15)
        ])
    }
    
    private func setupUserIdLabel(user: UserInfo) {
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(userIdLabel)
        NSLayoutConstraint.activate([
            userIdLabel.topAnchor.constraint(equalTo: residenceLabel.bottomAnchor),
            userIdLabel.leadingAnchor.constraint(equalTo: residenceLabel.leadingAnchor)
        ])
        userIdLabel.text = user.userId
    }
    
    private func setupIntroductionLabel(user: UserInfo) {
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(introductionLabel)
        NSLayoutConstraint.activate([
            introductionLabel.leadingAnchor.constraint(equalTo: userIdLabel.leadingAnchor),
            introductionLabel.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor),
            introductionLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        cardImageView.layer.addSublayer(gradientLayer)
    }
}
