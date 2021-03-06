//
//  GroupeventHomepageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/26.
//

import UIKit
import MapKit
import Kingfisher
import FirebaseAuth

class GroupEventHomePageViewController: UIViewController, UITextFieldDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let groupEventCEPViewController = GroupEventCEPENameVC()
    let groupEventDetailPageViewController = GroupEventDetailPageViewController()
    let notificationViewController = NotificationViewController()
    let searchController = UISearchController(searchResultsController: nil)
    let layout = UICollectionViewFlowLayout()
    var groupEventCollectionView: UICollectionView!
    var applyList = [ApplyList]()
    var blockList = [String]()
    
    var groupEvent = [GroupEvent]() {
        
        didSet {
            
            groupEventCollectionView.reloadData()
        }
    }
    var searching = false
    var searchGroupEvent = [GroupEvent]()
    
    var selectedEventId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Explore"
        self.hideKeyboardWhenTappedAround()
        setupNavigationBarItem()
        configureSearchController()
        setupBorderlineView()
        configureCellSize()
        groupEventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setupGroupEventCollectionView()
        groupEventCollectionView.register(GroupEventCollectionViewCell.self, forCellWithReuseIdentifier: GroupEventCollectionViewCell.identifier )
        groupEventCollectionView.dataSource = self
        groupEventCollectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupEventCollectionView.backgroundColor = .white
        
        FirebaseManger.shared.blockListListener { userInfo in
            self.blockList.removeAll()
            if let blockList = userInfo?.blockList {
                for blockId in blockList {
                    self.blockList.append(blockId)
                }
            }
            
            FirebaseManger.shared.fetchGroupEventCreatingInfo { (groupEvent) in
                
                self.groupEvent = groupEvent.filter({ groupEvent -> Bool in
                    !(self.blockList.contains(groupEvent.eventId))
                })
            }
        }
    }
    
    func setupNavigationBarItem() {
        let plusImage = UIImage.init(systemName: "plus")
        let notificationImage = UIImage.init(systemName: "bell")
        let plusButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(createNewEvent))
        let notificationButton = UIBarButtonItem(image: notificationImage, style: .plain, target: self, action: #selector(pushNotiVC))
        notificationButton.tintColor = .themeColor
        plusButton.tintColor = .themeColor
        self.navigationItem.setRightBarButtonItems([plusButton, notificationButton], animated: true)
        
    }
    
    private lazy var categorySegmentedControl: UISegmentedControl = {
        let categorySegmentedControl = UISegmentedControl(items: ["Top", "Recent"])
        categorySegmentedControl.tintColor = UIColor.blue
        categorySegmentedControl.backgroundColor = UIColor.themeColor
        categorySegmentedControl.selectedSegmentIndex = 0
        return categorySegmentedControl
    }()
    
    private lazy var borderlineView: UIView = {
        let borderlineView = UIView()
        borderlineView.backgroundColor = UIColor.hexStringToUIColor(hex: "F0F0F0")
        return borderlineView
    }()
    
    @objc private func createNewEvent() {
        navigationController?.pushViewController(groupEventCEPViewController, animated: true)
    }
    
    @objc private func pushNotiVC() {
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    private func setupBorderlineView() {
        borderlineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(borderlineView)
        NSLayoutConstraint.activate([
            borderlineView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            borderlineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            borderlineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            borderlineView.heightAnchor.constraint(equalToConstant: 1.5)
            
        ])
    }
    
    private func setupCategorySegmentedControl() {
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categorySegmentedControl)
        NSLayoutConstraint.activate([
            categorySegmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            categorySegmentedControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05)
        ])
    }
    private func setupGroupEventCollectionView() {
        groupEventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(groupEventCollectionView)
        NSLayoutConstraint.activate([
            groupEventCollectionView.topAnchor.constraint(equalTo: borderlineView.bottomAnchor),
            groupEventCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            groupEventCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            groupEventCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureCellSize() {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (self.view.frame.size.width / 3) - 5, height: (self.view.frame.size.width / 3) + 10)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if !text.isEmpty {
            searching = true
            searchGroupEvent.removeAll()
            for event in groupEvent {
                if event.title.lowercased().contains(text.lowercased()) {
                    searchGroupEvent.append(event)
                }
            }
        } else {
            searching = false
            searchGroupEvent.removeAll()
            searchGroupEvent = groupEvent
        }
        
        groupEventCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchGroupEvent.removeAll()
        groupEventCollectionView.reloadData()
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search a fun event!"
    }
    
}

extension GroupEventHomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching {
            
            return self.searchGroupEvent.count
            
        } else {
            
            return self.groupEvent.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = groupEventCollectionView.dequeueReusableCell(withReuseIdentifier: GroupEventCollectionViewCell.identifier,
                                                                      for: indexPath) as? GroupEventCollectionViewCell else { fatalError("Error") }
        
        if searching {
            
            cell.eventPhoto.kf.setImage(with: URL(string: self.searchGroupEvent[indexPath.row].eventPhoto))
            cell.eventTitleLabel.text = self.searchGroupEvent[indexPath.row].title
            cell.eventLocationLabel.text = self.searchGroupEvent[indexPath.row].location
            cell.eventDateLabel.text = "開始時間\n\(self.searchGroupEvent[indexPath.row].startTime)"
            cell.backgroundColor = UIColor.white
            cell.contentView.layer.cornerRadius = 15
            cell.contentView.layer.masksToBounds = true
            cell.shadowDecorate()
            
        } else {
            
            cell.eventPhoto.kf.setImage(with: URL(string: self.groupEvent[indexPath.row].eventPhoto))
            cell.eventTitleLabel.text = self.groupEvent[indexPath.row].title
            cell.eventLocationLabel.text = self.groupEvent[indexPath.row].location
            cell.eventDateLabel.text = "開始時間\n\(self.groupEvent[indexPath.row].startTime)"
            cell.backgroundColor = UIColor.white
            cell.contentView.layer.cornerRadius = 15
            cell.contentView.layer.masksToBounds = true
            cell.shadowDecorate()
            
        }
        
        cell.ellipsisButton.addTarget(self, action: #selector(ellipsis(sender:)), for: .touchUpInside)
        cell.ellipsisButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func ellipsis(sender: UIButton) {
        
        self.selectedEventId = self.groupEvent[sender.tag].eventId
        
        let alert = UIAlertController(title: "檢舉", message: "您的檢舉將會匿名，如果有人有立即的人身安全疑慮，請立即與當地緊急救護服務連絡，把握救援時間！檢舉內容：仇恨言論、符號、垃圾訊息、霸凌或騷擾、自殺或自殘、誤導或詐騙....等等", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let confirm = UIAlertAction(title: "確認檢舉", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            
            guard let eventId = self.selectedEventId else {
                return
            }
            
            FirebaseManger.shared.postGroupEventIdtoSelfBlockList(blockId: eventId)
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.view.frame.size.width) / 2 - 15), height: ((self.view.frame.size.width) / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        guard let selectedRow = groupEventCollectionView.indexPathsForSelectedItems?.first?.row else { return }
        
        let selectedGroupEvent = groupEvent[selectedRow]
        
        FirebaseManger.shared.fetchApplyListforOtherUser(eventId: selectedGroupEvent.eventId) { result in
            self.applyList = result
            
            let int = DateClass.compareOneDay(oneDay: self.groupEvent[selectedRow].endTime, withAnotherDay: Date())
            
            // 如果活動的senderId == 自己的Id 代表自己是團長（活動主辦）
            if selectedGroupEvent.senderId == userId {
                
                self.groupEventDetailPageViewController.isTheHost = true
                
                // 如果申請表列中有evenfId 且自己的Id是申請者Id，代表活動申請中（報名中）
            } else if self.applyList.isEmpty == false {
                
                self.groupEventDetailPageViewController.isTheHost = false
                self.groupEventDetailPageViewController.isRigisted = true
                
                // 如果申請表列沒有，且活動的attendee有自己的Id，代表已經加入該活動，（已是團員）
            } else if self.applyList.isEmpty == true && selectedGroupEvent.attendee.contains(userId) == true {
                
                self.groupEventDetailPageViewController.isTheHost = false
                self.groupEventDetailPageViewController.isRigisted = false
                self.groupEventDetailPageViewController.isAttendee = true
                
                // 如果申請表列沒有，且活動的attendee沒有自己的Id，代表（未報名）
            } else if self.applyList.isEmpty == true && selectedGroupEvent.attendee.contains(userId) == false {
                
                self.groupEventDetailPageViewController.isTheHost = false
                self.groupEventDetailPageViewController.isRigisted = false
                self.groupEventDetailPageViewController.isAttendee = false
                
                print("還沒報名")
                
            }
            
            if int == 1 || int == 0 {
                
                // 活動尚未過期
                self.groupEventDetailPageViewController.isExpired = false
                
            } else {
                
                // 活動過期
                self.groupEventDetailPageViewController.isExpired = true
            }
            
            self.groupEventDetailPageViewController.selectedGroupEvent = selectedGroupEvent
            self.groupEventDetailPageViewController.requestSenderId = userId
            self.navigationController?.pushViewController(self.groupEventDetailPageViewController, animated: true)
        }
        
    }
    
}

extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}
