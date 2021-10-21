//
//  ViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
// closure 記得加[weak self]

import UIKit
import FirebaseFirestore

class CardPageViewController: UIViewController {
    var cardHomePageView = CardHomePageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardHomePageView()
        setupCardImageView()
        cardImageView.alpha = 1
        setupCardIconImage()
        setupNameLabel()
        setupAgeLabel()
        setupResidenceLabel()
        setupIntroductionLabel()
        cardImageView.isUserInteractionEnabled = true
        cardImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        // Do any additional setup after loading the view.
    }
    private let cardImageView = CardImageView(frame: .zero, cardImage: UIImage(named: "photo")!)
    private let nameLabel = CardInfoLabel(frame: .zero, labelText: "Willyboy", labelFont: .systemFont(ofSize: 40, weight: .heavy))
    private let ageLabel = CardInfoLabel(frame: .zero, labelText: "26", labelFont: .systemFont(ofSize: 40, weight: .heavy))
    private let residenceLabel = CardInfoLabel(frame: .zero, labelText: "台北, 萬華", labelFont: .systemFont(ofSize: 20, weight: .regular))
    private let introductionLabel = CardInfoLabel(frame: .zero, labelText: "在台灣過60秒，非洲就過了一分鐘", labelFont: .systemFont(ofSize: 20, weight: .regular))
    private var cardIconImage = CardImageView(frame: .zero, cardImage: UIImage(named: "heart")!)
    
    private func setupCardHomePageView() {
        cardHomePageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardHomePageView)
        NSLayoutConstraint.activate([
            cardHomePageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cardHomePageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cardHomePageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cardHomePageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    private func setupCardImageView() {
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardImageView)
        NSLayoutConstraint.activate([
            cardImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cardImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            cardImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            cardImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7)
        ])
    }
    private func setupCardIconImage() {
        cardIconImage.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(cardIconImage)
        NSLayoutConstraint.activate([
            cardIconImage.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor),
            cardIconImage.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor),
            cardIconImage.widthAnchor.constraint(equalTo: cardImageView.widthAnchor, multiplier: 0.3),
            cardIconImage.heightAnchor.constraint(equalTo: cardImageView.widthAnchor, multiplier: 0.3)
        ])
    }
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -150),
            nameLabel.widthAnchor.constraint(equalToConstant: 180),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupAgeLabel() {
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            ageLabel.widthAnchor.constraint(equalToConstant: 75),
            ageLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupResidenceLabel() {
        residenceLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.addSubview(residenceLabel)
        NSLayoutConstraint.activate([
            residenceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            residenceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            residenceLabel.heightAnchor.constraint(equalToConstant: 30),
            residenceLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
        private func setupIntroductionLabel() {
            introductionLabel.translatesAutoresizingMaskIntoConstraints = false
            cardImageView.addSubview(introductionLabel)
            NSLayoutConstraint.activate([
                introductionLabel.leadingAnchor.constraint(equalTo: residenceLabel.leadingAnchor),
                introductionLabel.topAnchor.constraint(equalTo: residenceLabel.bottomAnchor, constant: 5),
                introductionLabel.widthAnchor.constraint(equalToConstant: 200)
            ])
        }
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: self.view)
        let xFromCenter = cardImageView.center.x - self.view.center.x
        let yFromBottom = self.view.frame.height - cardImageView.center.y
        cardImageView.center = CGPoint(x: self.view.center.x + point.x, y: self.view.center.y + point.y)
        cardImageView.transform = CGAffineTransform(rotationAngle: atan(xFromCenter / yFromBottom))
        if xFromCenter > 0 {
            cardIconImage = CardImageView(frame: .zero, cardImage: UIImage(named: "heart")!)
            cardIconImage.alpha = 1
            
        } else {
            cardIconImage = CardImageView(frame: .zero, cardImage: UIImage(named: "no")!)
            cardIconImage.alpha = 1
        }
        cardIconImage.alpha = abs(xFromCenter) / self.view.center.x
        if gesture.state == .ended {
            if  cardImageView.center.x < 75 {
                // Move off to the left side
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    cardImageView.center = CGPoint(x: cardImageView.center.x - 200, y: cardImageView.center.y)
                    self.cardImageView.alpha = 0
                }) { (finish) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.cardImageView.image = nil
                        self.cardImageView.removeFromSuperview()
                        print(self.cardImageView.image as Any)
                        print(self.cardImageView)
                    })
                }
                return
            } else if cardImageView.center.x > (UIScreen.width - 75) {
                // Move off to the right side
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    self.cardImageView.center = CGPoint(x: cardImageView.center.x + 200, y: cardImageView.center.y)
                    self.cardImageView.alpha = 0
                }) { (finish) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.cardImageView.image = nil
                    })
                }
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.cardImageView.center = self.view.center
                self.cardIconImage.alpha = 0
                self.cardImageView.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
}
