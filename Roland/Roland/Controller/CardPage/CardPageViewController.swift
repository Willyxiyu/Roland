//
//  ViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/18.
// closure 記得加[weak self]

import UIKit

class CardPageViewController: UIViewController {
    
    var userInfoForScalingCard = [String]()
    var cardView = UIView()
    
    private var noNewUserImageView = UIImageView(image: UIImage(named: "探索結束"))
    
    lazy var rolandImageView: UIImageView = {
        let rolandImageView = UIImageView()
        rolandImageView.image = UIImage(named: "rolandicon")
        rolandImageView.setImageColor(color: UIColor.themeColor!)
        rolandImageView.contentMode = .scaleAspectFit
        rolandImageView.clipsToBounds = true
        return rolandImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupRolandImageView()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
     
        fetchUserLikeAndDislikeList()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        
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
    
    func setupCard(_ card: CardView) {
        card.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            card.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor)
        ])
        
        card.delegate = self
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
    
    func fetchUserLikeAndDislikeList() {
        // fetch the userId in userInfo's likelist and dislikelist array
        FirebaseManger.shared.fetchUserInfobyUserId { result in
            
            if let userId = result?.userId {
                
                self.userInfoForScalingCard = [userId]
                
            }
            if let likeList = result?.likeList {
                
                for userId in likeList {
                    
                    self.userInfoForScalingCard.append(userId)
                }
            }
            
            if let  dislikeList = result?.dislikeList {
                
                for userId in dislikeList {
                    
                    self.userInfoForScalingCard.append(userId)
                }
            }
            
            self.fetchUserListForScalingCard()
        }
    }
    
    func fetchUserListForScalingCard() {
        // make the card show up with correct user without user in both lists and ourself.
        FirebaseManger.shared.fetchUserListForScalingCard { result in
            let array = result.filter { userInfo -> Bool in
                guard let idd = userInfo.userId else { return false }
                return !(self.userInfoForScalingCard.contains(idd))
            }
            
            array.forEach { (userInfo) in
                
                self.setupCard(CardView(user: userInfo))
            }
        }
    }
}

extension CardPageViewController: SlingCardUserIdDelegate {
    
    func sendingUserIdFromLeft(_ userId: String) {
        
        FirebaseManger.shared.postAccepterIdtoSelfDislikeList(accepterId: userId)
        
    }
    
    func sendingUserIdFromRight(_ userId: String) {
        // sliding right adding other's id to self dislikeList and remove the card form the screen
        
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
    }
}
