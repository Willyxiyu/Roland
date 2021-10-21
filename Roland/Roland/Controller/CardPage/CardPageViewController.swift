//
//  ViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
// closure 記得加[weak self]

import UIKit

class CardPageViewController: UIViewController {
    var cardHomePageView = CardHomePageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        cardHomePageView.backgroundColor = .white
        setupCardHomePageView()
        setupCardView()
        setupCardIcon()
        setupNameLabel()
        setupBirthLabel()
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        // Do any additional setup after loading the view.
    }
    lazy var cardView: UIImageView = {
        let cardView = UIImageView()
        cardView.image = UIImage(named: "photo")
        cardView.contentMode = .scaleAspectFill
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 15
        return cardView
    }()
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.textColor = UIColor.white
        nameLabel.text = "WillyBoy"
        return nameLabel
    }()
    lazy var birthLabel: UILabel = {
        let birthLabel = UILabel()
        birthLabel.font = UIFont.medium(size: 20)
        birthLabel.textColor = UIColor.white
        birthLabel.text = "26"
        return birthLabel
    }()
    lazy var cardIcon: UIImageView = {
        let cardIcon = UIImageView()
        cardIcon.image = UIImage(named: "heart")
        cardIcon.alpha = 0
        return cardIcon
    }()
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
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 50),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -100),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupBirthLabel() {
        birthLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(birthLabel)
        NSLayoutConstraint.activate([
            birthLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            birthLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            birthLabel.widthAnchor.constraint(equalToConstant: 50),
            birthLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7)
        ])
    }
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: self.view)
        let xFromCenter = cardView.center.x - self.view.center.x
        let yFromBottom = self.view.frame.height - cardView.center.y
        cardView.center = CGPoint(x: self.view.center.x + point.x, y: self.view.center.y + point.y)
        cardView.transform = CGAffineTransform(rotationAngle: atan(xFromCenter / yFromBottom))
        if xFromCenter > 0 {
            cardIcon.image = UIImage(named: "heart")
        } else {
            cardIcon.image = UIImage(named: "no")
        }
        cardIcon.alpha = abs(xFromCenter) / self.view.center.x
        if gesture.state == .ended {
            if  cardView.center.x < 75 {
                // Move off to the left side
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    cardView.center = CGPoint(x: cardView.center.x - 200, y: cardView.center.y)
                    self.cardView.alpha = 0
                }) { (finish) in
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        self.cardView.image = nil
                        //                        self.cardHomePageView.cardView = nil
                        self.cardView.removeFromSuperview()
                        print(self.cardView.image as Any)
                        print(self.cardView)
                    })
                }
                return
            } else if cardView.center.x > (UIScreen.width - 75) {
                // Move off to the right side
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    self.cardView.center = CGPoint(x: cardView.center.x + 200, y: cardView.center.y)
                    self.cardView.alpha = 0
                }) { (finish) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.cardView.image = nil
                    })
                }
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.cardView.center = self.view.center
                self.cardIcon.alpha = 0
                self.cardView.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
}
