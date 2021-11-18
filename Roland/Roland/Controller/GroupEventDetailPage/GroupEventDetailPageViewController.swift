//
//  GroupEventCEPFEPVC.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//
//
import Foundation
import Firebase
import UIKit
import FirebaseStorage
import Kingfisher
import AVFoundation

class GroupEventDetailPageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let publicCommentViewController = PublicCommentViewController()
    let privateCommentViewController = PrivateCommentViewController()
    let reEditGroupEventViewController = ReEditGroupEventViewController()
    
    let tableView = UITableView()
    var isTheHost: Bool?
    var isRigisted: Bool?
    var isAttendee: Bool?
    var isExpired: Bool?
    var selectedGroupEvent: GroupEvent? {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    var requestSenderId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Event"
        setupTableView()
        tableView.register(GEPhotoCell.self, forCellReuseIdentifier: String(describing: GEPhotoCell.self))
        tableView.register(GEDetailPageTitleCell.self, forCellReuseIdentifier: String(describing: GEDetailPageTitleCell.self))
        tableView.register(GEDateCell.self, forCellReuseIdentifier: String(describing: GEDateCell.self))
        tableView.register(GElocationCell.self, forCellReuseIdentifier: String(describing: GElocationCell.self))
        tableView.register(GEDetailCell.self, forCellReuseIdentifier: String(describing: GEDetailCell.self))
        tableView.register(GEIntroCell.self, forCellReuseIdentifier: String(describing: GEIntroCell.self))
        tableView.register(GEHostandAttendeesCell.self, forCellReuseIdentifier: String(describing: GEHostandAttendeesCell.self))
        tableView.register(GEMessageCell.self, forCellReuseIdentifier: String(describing: GEMessageCell.self))
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        setupBorderLine()
        setupCancelButton()
        setupCancelRegisButton()
        setupEditButton()
        setupShareEventButton()
        setupRegisButton()
        setupQuitEventButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        
        guard let docId = selectedGroupEvent?.eventId else {
            
            fatalError("error")
        }
        FirebaseManger.shared.fetchUpdateGEventInfoFromReEditPage(docId: docId) { result in
            
            self.selectedGroupEvent = result
        }
        guard let isTheHost = isTheHost else { fatalError("error") }
        
        if isTheHost == true && isExpired == false {
            cancelButton.isHidden = false
            editButton.isHidden = false
            shareEventButton.isHidden = true
            regisButton.isHidden = true
            cancelRegisButton.isHidden = true
            quitEventButton.isHidden = true
            
        } else if isTheHost == false && isRigisted == true && isExpired == false {
            
            cancelRegisButton.isHidden = false
            shareEventButton.isHidden = false
            cancelButton.isHidden = true
            editButton.isHidden = true
            regisButton.isHidden = true
            quitEventButton.isHidden = true
            
        } else if isTheHost == false && isRigisted == false && isAttendee == false && isExpired == false {
            
            shareEventButton.isHidden = false
            regisButton.isHidden = false
            cancelButton.isHidden = true
            editButton.isHidden = true
            cancelRegisButton.isHidden = true
            quitEventButton.isHidden = true
            
        } else if isTheHost == false && isRigisted == false && isAttendee == true && isExpired == false {
            
            shareEventButton.isHidden = false
            regisButton.isHidden = true
            cancelButton.isHidden = true
            editButton.isHidden = true
            cancelRegisButton.isHidden = true
            quitEventButton.isHidden = false
            
        } else if isExpired == true {
            
            cancelButton.isHidden = true
            cancelRegisButton.isHidden = true
            editButton.isHidden = true
            shareEventButton.isHidden = true
            regisButton.isHidden = true
            quitEventButton.isHidden = true
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
    }
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    lazy var borderLine: UIView = {
        let borderLine = UIView()
        borderLine.backgroundColor = UIColor.lightGray
        return borderLine
    }()
    
    private func setupBorderLine() {
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(borderLine)
        NSLayoutConstraint.activate([
            borderLine.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 1),
            borderLine.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    // left
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消活動", for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        cancelButton.isEnabled = true
        return cancelButton
    }()
    
    @objc func cancelEvent() {
        
        guard let eventId = selectedGroupEvent?.eventId else { return }
        
        let alert = UIAlertController(title: "刪除活動", message: "刪除後無法回復", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "敵不動我不動", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "確認刪除", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            FirebaseManger.shared.deleteGroupEventCreatingInfo(docId: eventId)
            self.navigationController?.popViewController(animated: true)
            
        })
        alert.addAction(confirm)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.setTitle("編輯活動", for: .normal)
        editButton.layer.cornerRadius = 10
        editButton.backgroundColor = UIColor.themeColor
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        editButton.addTarget(self, action: #selector(editEvent), for: .touchUpInside)
        editButton.isEnabled = true
        return editButton
    }()
    
    @objc func editEvent() {
        reEditGroupEventViewController.selectedGroupEvent = self.selectedGroupEvent
        navigationController?.pushViewController(reEditGroupEventViewController, animated: true)
        
    }
    
    // left
    lazy var regisButton: UIButton = {
        let regisButton = UIButton()
        regisButton.setTitle("報名活動", for: .normal)
        regisButton.layer.cornerRadius = 10
        regisButton.layer.borderWidth = 1
        regisButton.setTitleColor(UIColor.black, for: .normal)
        regisButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        regisButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        regisButton.addTarget(self, action: #selector(registerEvent), for: .touchUpInside)
        regisButton.isSelected = false
        regisButton.setTitle("取消申請", for: .selected)
        
        return regisButton
    }()
    
    @objc func registerEvent() {
        
        if regisButton.isSelected == true {
            
            regisButton.isSelected = false
            
            if let eventId =  selectedGroupEvent?.eventId {
                
                FirebaseManger.shared.fetchApplyListforCancelRegister(eventId: eventId) { result in
                    
                    if let docId = result?.documentId {
                        
                        FirebaseManger.shared.deleteUserIdFromApplyList(documentId: docId)
                        
                        print("取消報名")
                        
                    }
                }
            }
            
        } else {
            
            regisButton.isSelected = true
            
            guard let eventId = selectedGroupEvent?.eventId else { return }
            
            guard let acceptedId = selectedGroupEvent?.senderId else { return }
            
            FirebaseManger.shared.postSenderIdtoApplyList(eventId: eventId, acceptedId: acceptedId)
            
            print("我要報名")
        }
    }
    
    // left
    lazy var cancelRegisButton: UIButton = {
        let cancelRegisButton = UIButton()
        cancelRegisButton.setTitle("取消報名", for: .normal)
        cancelRegisButton.layer.cornerRadius = 10
        cancelRegisButton.layer.borderWidth = 1
        cancelRegisButton.setTitleColor(UIColor.black, for: .normal)
        cancelRegisButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        cancelRegisButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cancelRegisButton.addTarget(self, action: #selector(cancelRegister), for: .touchUpInside)
        return cancelRegisButton
    }()
    
    @objc func cancelRegister() {
        
        if let eventId =  selectedGroupEvent?.eventId {
            
            FirebaseManger.shared.fetchApplyListforCancelRegister(eventId: eventId) { result in
                
                if let docId = result?.documentId {
                    
                    FirebaseManger.shared.deleteUserIdFromApplyList(documentId: docId)
                    
                    print("取消報名")
                    
                }
            }
        }
    }
    
    // left
    lazy var quitEventButton: UIButton = {
        let quitEventButton = UIButton()
        quitEventButton.setTitle("退出活動", for: .normal)
        quitEventButton.layer.cornerRadius = 10
        quitEventButton.layer.borderWidth = 1
        quitEventButton.setTitleColor(UIColor.black, for: .normal)
        quitEventButton.layer.borderColor = UIColor.secondThemeColor?.cgColor
        quitEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        quitEventButton.addTarget(self, action: #selector(quitEvent), for: .touchUpInside)
//        quitEventButton.setTitle("已退出活動", for: .disabled)
        return quitEventButton
    }()
    
    @objc func quitEvent() {
        
            if let eventId =  selectedGroupEvent?.eventId {
                
                let alert = UIAlertController(title: "退出活動", message: "刪除後無法反悔", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "懸崖勒馬", style: .cancel, handler: nil)
                
                let confirm = UIAlertAction(title: "確認退出", style: .default, handler: { [weak self] _ in
                    
                    guard let self = self else { return }
                    
                    FirebaseManger.shared.deleteAttendeeIdForQuitEvent(docId: eventId)
                    
                    self.navigationController?.popViewController(animated: true)
                    
                })
                
                alert.addAction(confirm)
                
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    lazy var shareEventButton: UIButton = {
        let shareEventButton = UIButton()
        shareEventButton.setTitle("分享活動", for: .normal)
        shareEventButton.layer.cornerRadius = 10
        shareEventButton.backgroundColor = UIColor.themeColor
        shareEventButton.setTitleColor(UIColor.white, for: .normal)
        shareEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        shareEventButton.addTarget(self, action: #selector(shareEvent), for: .touchUpInside)
        shareEventButton.isEnabled = true
        return shareEventButton
    }()
    
    @objc func shareEvent() {
        
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            cancelButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            editButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            editButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            editButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupRegisButton() {
        regisButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(regisButton)
        NSLayoutConstraint.activate([
            regisButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            regisButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            regisButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            regisButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupCancelRegisButton() {
        cancelRegisButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cancelRegisButton)
        NSLayoutConstraint.activate([
            cancelRegisButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            cancelRegisButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            cancelRegisButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            cancelRegisButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupQuitEventButton() {
        quitEventButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(quitEventButton)
        NSLayoutConstraint.activate([
            quitEventButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            quitEventButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            quitEventButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            quitEventButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.07)
        ])
    }
    
    private func setupShareEventButton() {
        shareEventButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(shareEventButton)
        NSLayoutConstraint.activate([
            shareEventButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            shareEventButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            shareEventButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            shareEventButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.07)
        ])
    }
    
}
extension GroupEventDetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let HAlist = ["活動主辦", "參與者"]
        //        let commentList = ["公開留言板", "團員留言板", "影音區"]
        let commentList = ["公開留言板", "團員留言板"]
        
        guard let HAcell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEHostandAttendeesCell.self)"), for: indexPath) as? GEHostandAttendeesCell else { fatalError("Error") }
        
        guard let COcell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEMessageCell.self)"), for: indexPath) as? GEMessageCell else { fatalError("Error") }
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPhotoCell.self)"), for: indexPath) as? GEPhotoCell else { fatalError("Error") }
            
            guard let photo = selectedGroupEvent?.eventPhoto else { fatalError("Error") }
            cell.photoImageView.kf.setImage(with: URL(string: photo))
            cell.eventImageButton.isHidden = true
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDetailPageTitleCell.self)"),
                                                           for: indexPath) as? GEDetailPageTitleCell else { fatalError("Error") }
            cell.titleLabel.text = selectedGroupEvent?.title
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDateCell.self)"),
                                                           for: indexPath) as? GEDateCell else { fatalError("Error") }
            
            guard let startTime = selectedGroupEvent?.startTime else {
                fatalError("error")
            }
            guard let endTime = selectedGroupEvent?.endTime else {
                fatalError("error")
            }
            
            cell.dateLabel.text = String("\(startTime)\n\(endTime)")
            
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GElocationCell.self)"),
                                                           for: indexPath) as? GElocationCell else { fatalError("Error") }
            
            cell.locationLabel.text = selectedGroupEvent?.location
            
            return cell
            
        case 4:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDetailCell.self)"), for: indexPath) as? GEDetailCell else { fatalError("Error") }
            
            guard let people = selectedGroupEvent?.maximumOfPeople else { fatalError("error")  }
            
            cell.eventDetailTitleLabel.text = "活動人數"
            cell.eventDetailLabel.text = String("\(people)")
            
            return cell
            
        case 5:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEIntroCell.self)"),
                                                           for: indexPath) as? GEIntroCell else { fatalError("Error") }
            cell.eventIntroLabel.text = selectedGroupEvent?.info
            
            return cell
            
        case 6:
            
            HAcell.titleLabel.text = HAlist[0]
            
            guard let userId = selectedGroupEvent?.senderId else {
                
                fatalError("error") }
            
            HAcell.userId = [userId]
            
            return HAcell
            
        case 7:
            
            HAcell.titleLabel.text = HAlist[1]
            
            guard let userId = selectedGroupEvent?.attendee else {
                
                fatalError("error") }
            
            HAcell.userId = userId
            
            return HAcell
            
        case 8:
            
            COcell.commentLabel.text = commentList[0]
            
            return COcell
            
        case 9:
            
            COcell.commentLabel.text = commentList[1]
            
            return COcell
            
        default:
            
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        switch indexPath.row {
            
        case 0 : break
            
        case 1 : break
            
        case 2 : break
            
        case 3 : break
            
        case 4 : break
            
        case 5 : break
            
        case 6 : break
            
        case 7 : break
            
        case 8 :
            
            guard let eventId = selectedGroupEvent?.eventId else {
                fatalError("error")
            }
            
            publicCommentViewController.eventId = eventId
            
            navigationController?.pushViewController(publicCommentViewController, animated: true)
            
        case 9 :
            
            guard let eventId = selectedGroupEvent?.eventId else {
                fatalError("error")
            }
            
            privateCommentViewController.eventId = eventId
            
            navigationController?.pushViewController(privateCommentViewController, animated: true)
            
        case 10 : break
            
        default:
            
            break
        }
    }
}
