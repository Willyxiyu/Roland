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
        setupCardView()
        cardHomePageView.cardView.isUserInteractionEnabled = true
        cardHomePageView.cardView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        // Do any additional setup after loading the view.
    }
    private func setupCardView() {
        cardHomePageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardHomePageView)
        NSLayoutConstraint.activate([
            cardHomePageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cardHomePageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cardHomePageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cardHomePageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    @objc func handlePanGesture(_ gesture:UIPanGestureRecognizer) {
        let point = gesture.translation(in: self.view)
        let xFromCenter = cardHomePageView.cardView.center.x - self.view.center.x
        let yFromBottom = self.view.frame.height - cardHomePageView.cardView.center.y
        cardHomePageView.cardView.center = CGPoint(x: self.view.center.x + point.x, y: self.view.center.y + point.y)
        cardHomePageView.cardView.transform = CGAffineTransform(rotationAngle: atan(xFromCenter / yFromBottom))
        if xFromCenter > 0 {
            cardHomePageView.cardIcon.image = UIImage(named: "heart")
        } else {
            cardHomePageView.cardIcon.image = UIImage(named: "no")
        }
        cardHomePageView.cardIcon.alpha = abs(xFromCenter) / self.view.center.x
        if gesture.state == .ended {
            if  cardHomePageView.cardView.center.x < 75 {
                //Move off to the left side
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    self.cardHomePageView.cardView.center = CGPoint(x: cardHomePageView.cardView.center.x - 200, y: cardHomePageView.cardView.center.y)
                    self.cardHomePageView.cardView.alpha = 0
                })
                return
            } else if cardHomePageView.cardView.center.x > (UIScreen.width - 75) {
                //Move off to the right side
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    self.cardHomePageView.cardView.center = CGPoint(x: cardHomePageView.cardView.center.x + 200, y: cardHomePageView.cardView.center.y)
                    self.cardHomePageView.cardView.alpha = 0
                })
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.cardHomePageView.cardView.center = self.view.center
                self.cardHomePageView.cardIcon.alpha = 0
                self.cardHomePageView.cardView.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
}
