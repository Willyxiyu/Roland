////
////  GroupEventCEPFEPVC.swift
////  Roland
////
////  Created by 林希語 on 2021/10/27.
////
//
import Foundation
import Firebase
import UIKit
import FirebaseStorage
import Kingfisher

class GroupEventDetailPageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let publicCommentViewController = PublicCommentViewController()
    let privateCommentViewController = PrivateCommentViewController()
    
    let tableView = UITableView()
    var isTheHost: Bool?
    var isRigisted: Bool?
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
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
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
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
extension GroupEventDetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let HAlist = ["活動主辦", "參與者"]
        let commentList = ["公開留言板", "團員留言板", "影音區"]
        
        guard let HAcell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEHostandAttendeesCell.self)"), for: indexPath) as? GEHostandAttendeesCell else { fatalError("Error") }
        
        guard let COcell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEMessageCell.self)"), for: indexPath) as? GEMessageCell else { fatalError("Error") }
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPhotoCell.self)"), for: indexPath) as? GEPhotoCell else { fatalError("Error") }
            
            guard let photo = selectedGroupEvent?.eventPhoto else { fatalError("Error") }
            cell.photoImageView.kf.setImage(with: URL(string: photo))
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDetailPageTitleCell.self)"),
                                                           for: indexPath) as? GEDetailPageTitleCell else { fatalError("Error") }
            cell.titleLabel.text = selectedGroupEvent?.title
            
            guard let isTheHost = isTheHost else { fatalError("error") }
            
            if isTheHost == true {
                
                cell.shareEventButton.isHidden = true
                cell.regisButton.isHidden = true
                cell.cancelRegisButton.isHidden = true
                
            } else if isTheHost == false && isRigisted == true {
                
                cell.cancelButton.isHidden = true
                cell.editButton.isHidden = true
                cell.regisButton.isHidden = true
                
            } else if isTheHost == false && isRigisted == false {
                
                cell.cancelButton.isHidden = true
                cell.editButton.isHidden = true
                cell.cancelRegisButton.isHidden = true
                
            }
            
            cell.cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
            //            cell.shareEventButton.addTarget(self, action: #selector(shareEvent), for: .touchUpInside)
            cell.regisButton.addTarget(self, action: #selector(registerEvent), for: .touchUpInside)
            
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
            
            return HAcell
            
        case 7:
            
            HAcell.titleLabel.text = HAlist[1]
            
            return HAcell
            
        case 8:
            
            COcell.commentLabel.text = commentList[0]
            
            return COcell
            
        case 9:
            
            COcell.commentLabel.text = commentList[1]
            
            return COcell
            
        case 10:
            
            COcell.commentLabel.text = commentList[2]
            
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
            
            navigationController?.pushViewController(publicCommentViewController, animated: true)
        
        case 9 : 
            
            navigationController?.pushViewController(privateCommentViewController, animated: true)
        
        case 10 : break
            
        default:
            
            break
        }
    }
    
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
    
    @objc func registerEvent() {
        
        guard let requestSenderId = requestSenderId else { return }
        
        guard let eventId = selectedGroupEvent?.eventId else { return }
        
        guard let acceptedId = selectedGroupEvent?.senderId else { return }
        
        FirebaseManger.shared.postSenderIdtoApplyList(eventId: eventId, requestSenderId: requestSenderId, acceptedId: acceptedId)
    }
    
}
