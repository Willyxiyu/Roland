//
//  ViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
// closure 記得加[weak self]

import UIKit
import FirebaseFirestore

class CardPageViewController: UIViewController {
    
    var useFilter: Bool = false
    
    let meetUpFilterViewController = MeetUpFilterViewController()
//    var card: CardView?
    var cardView = UIView()
    private var userInfo = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupRolandImageView()
        setupFilterButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        if !useFilter {

            fetchUsers()
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false

    }

    lazy var rolandImageView: UIImageView = {
        let rolandImageView = UIImageView()
        
        rolandImageView.image = UIImage(named: "rolandicon")
        rolandImageView.setImageColor(color: UIColor.themeColor!)
        rolandImageView.contentMode = .scaleAspectFit
        rolandImageView.clipsToBounds = true
        return rolandImageView
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.contentMode = .scaleAspectFit
        filterButton.alpha = 0.5
        filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
        return filterButton
    }()
    
    @objc func openFilter() {
        navigationController?.pushViewController(meetUpFilterViewController, animated: true)
    }
    
    private func setupRolandImageView() {
        rolandImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(rolandImageView)
        NSLayoutConstraint.activate([
            rolandImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            rolandImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            rolandImageView.heightAnchor.constraint(equalToConstant: 50),
            rolandImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.centerYAnchor.constraint(equalTo: rolandImageView.centerYAnchor, constant: -5),
            filterButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            filterButton.widthAnchor.constraint(equalToConstant: 30),
            filterButton.heightAnchor.constraint(equalToConstant: 30)
        ])
       
    }
    
    private func fetchUsers() {
        FirebaseManger.shared.getUserInfoFromFirestore { (userInfo) in
            self.userInfo.removeAll()
            self.userInfo = userInfo
            self.userInfo.forEach { (userInfo) in
//                self.card = CardView(user: userInfo)
                self.setupCard(CardView(user: userInfo))
            }
        }
        
    }
    
    func setupCard(_ card: CardView) {
        card.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            card.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor)
        ])
    }
    
    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            cardView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75)
        ])
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
