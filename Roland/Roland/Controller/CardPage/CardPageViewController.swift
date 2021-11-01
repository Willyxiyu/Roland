//
//  ViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
// closure 記得加[weak self]

import UIKit
import FirebaseFirestore

class CardPageViewController: UIViewController {
    var cardView = UIView()
    var cardHomePageView = CardHomePageView()
    private var userInfo = [UserInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupCardHomePageView()
        setupCardView()
        setupLogingView()
        setupLogingButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       fetchUsers()
        
    }
    lazy var logingView: UIView = {
        let logingView = UIView()
        logingView.backgroundColor = UIColor.themeColor
        return logingView
    }()
    
    lazy var logingButton: UIButton = {
        let logingButton = UIButton()
        logingButton.setTitle("登入", for: .normal)
        logingButton.layer.cornerRadius = 20
        logingButton.layer.borderWidth = 1
        logingButton.setTitleColor(UIColor.gray, for: .normal)
        logingButton.backgroundColor = UIColor.white
        logingButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        logingButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        logingButton.isEnabled = true
        logingButton.addTarget(self, action: #selector(dismissLogingView), for: .touchUpInside)
        return logingButton
    }()
    
   @objc func dismissLogingView() {
       
       tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.logingView.alpha = 0
        }
    }
    
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
    
    private func fetchUsers() {
        FirebaseManger.shared.getUserInfoFromFirestore { (userInfo) in
            
            self.userInfo = userInfo
            self.userInfo.forEach { (userInfo) in
                let card = CardView(user: userInfo)
                card.translatesAutoresizingMaskIntoConstraints = false
                self.cardView.addSubview(card)
                NSLayoutConstraint.activate([
                    card.topAnchor.constraint(equalTo: self.cardView.topAnchor),
                    card.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
                    card.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
                    card.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor)
                ])
            }
        }
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
    
    private func setupLogingView() {
        logingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logingView)
        NSLayoutConstraint.activate([
            logingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            logingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            logingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            logingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupLogingButton() {
        logingButton.translatesAutoresizingMaskIntoConstraints = false
        logingView.addSubview(logingButton)
        NSLayoutConstraint.activate([
            logingButton.centerXAnchor.constraint(equalTo: logingView.centerXAnchor),
            logingButton.bottomAnchor.constraint(equalTo: logingView.bottomAnchor, constant: -100),
            logingButton.widthAnchor.constraint(equalTo: logingView.widthAnchor, multiplier: 0.7),
            logingButton.heightAnchor.constraint(equalTo: logingView.heightAnchor, multiplier: 0.05)
        ])
    }
}
