//
//  CardView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
//

import UIKit

class CardHomePageView: UIView {
    // MARK: - UIProperties
    lazy var rolandLabel: UILabel = {
        let rolandLabel = UILabel()
        rolandLabel.textColor = UIColor.themeColor
        rolandLabel.font = UIFont.medium(size: 20)
        rolandLabel.text = "Roland"
        return rolandLabel
    }()
    lazy var cardView: UIImageView = {
        let cardView = UIImageView()
        cardView.image = UIImage(named: "PS5")
        cardView.contentMode = .scaleAspectFill
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 15
        return cardView
    }()
    lazy var cardIcon: UIImageView = {
        let cardIcon = UIImageView()
        cardIcon.image = UIImage(named: "heart")
        cardIcon.alpha = 0
        return cardIcon
    }()
    // MARK: - init
    init() {
      super.init(frame: .zero)
        setupRolandLabel()
        setupCardView()
        setupCardIcon()
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
    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ])
    }
    private func setupCardIcon() {
        cardIcon.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardIcon)
        NSLayoutConstraint.activate([
            cardIcon.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardIcon.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3),
            cardIcon.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3)
        ])
    }
}
