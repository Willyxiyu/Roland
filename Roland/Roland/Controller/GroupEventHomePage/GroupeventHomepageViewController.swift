//
//  GroupeventHomepageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/26.
//

import UIKit
import MapKit
import Kingfisher

class GroupEventHomePageViewController: UIViewController, UITextFieldDelegate {
    
    let groupEventCEPViewController = GroupEventCEPENameVC()
    let groupEventDetailPageViewController = GroupEventDetailPageViewController()
    let notificationViewController = NotificationViewController()
    
    let layout = UICollectionViewFlowLayout()
    var groupEventCollectionView: UICollectionView!
    var applyList = [ApplyList]()
    
    // eventHostid
//    var requestSenderId = "DoIscQXJzIbQfJDTnBVm"
    
    // otheruserid
//    var requestSenderId = "GW9pTXyhawNoomsCeoZc"
    var requestSenderId = "djhfbsjdfhsdfsdfs"
    
    var groupEvent = [GroupEvent]() {
        
        didSet {
            
            groupEventCollectionView.reloadData()
            
            print(groupEvent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Explore"
        setupSearchTextField()
        setupBorderlineView()
//        setupCategorySegmentedControl()
        setupNavigationBarItem()
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
        
        FirebaseManger.shared.fetchGroupEventCreatingInfo { (groupEvent) in
            
            self.groupEvent = groupEvent
        }
    }
    
    func setupNavigationBarItem() {
        let plusImage = UIImage.init(systemName: "plus")
        let notificationImage = UIImage.init(systemName: "bell")
      
        let plusButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(createNewEvent))
        let notificationButton = UIBarButtonItem(image: notificationImage, style: .plain, target: self, action: #selector(pushNotiVC))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.themeColor
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
    
    private lazy var searchTextField: UITextField = {
        
        guard let image = UIImage(systemName: "magnifyingglass") else { fatalError("error") }
        let searchTextField = UITextField()
        searchTextField.setLeftPaddingPoints(10)
        searchTextField.backgroundColor = UIColor.hexStringToUIColor(hex: "F0F0F0")
        searchTextField.placeholder = "Search upcoming events!"
        searchTextField.setLeftView(image: image)
        searchTextField.layer.cornerRadius = 10
        return searchTextField
    }()
    
    @objc private func createNewEvent() {
        navigationController?.pushViewController(groupEventCEPViewController, animated: true)
    }
    
    @objc private func pushNotiVC() {
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    private func setupSearchTextField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            searchTextField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.04)
        ])
    }
    
    private func setupBorderlineView() {
        borderlineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(borderlineView)
        NSLayoutConstraint.activate([
            borderlineView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
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
}

extension GroupEventHomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = groupEventCollectionView.dequeueReusableCell(withReuseIdentifier: GroupEventCollectionViewCell.identifier,
                                                                      for: indexPath) as? GroupEventCollectionViewCell else { fatalError("Error") }
        
        cell.eventPhoto.kf.setImage(with: URL(string: self.groupEvent[indexPath.row].eventPhoto))
        cell.eventTitleLabel.text = self.groupEvent[indexPath.row].title
        cell.eventLocationLabel.text = self.groupEvent[indexPath.row].location
        cell.eventDateLabel.text = self.groupEvent[indexPath.row].startTime
        cell.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.masksToBounds = true
        cell.shadowDecorate()
        return cell
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
        
        guard let selectedRow = groupEventCollectionView.indexPathsForSelectedItems?.first?.row else { return }
        
        let selectedGroupEvent = groupEvent[selectedRow]
        
        FirebaseManger.shared.fetchApplyListforOtherUser(eventId: selectedGroupEvent.eventId, requestSenderId: requestSenderId) { result in
            self.applyList = result
            
            if selectedGroupEvent.senderId == self.requestSenderId {
                
                self.groupEventDetailPageViewController.isTheHost = true
                
            } else if self.applyList.isEmpty == false {
                
                self.groupEventDetailPageViewController.isTheHost = false
                self.groupEventDetailPageViewController.isRigisted = true
                
            } else if self.applyList.isEmpty == true {
                
                self.groupEventDetailPageViewController.isTheHost = false
                self.groupEventDetailPageViewController.isRigisted = false
            }
            self.groupEventDetailPageViewController.selectedGroupEvent = selectedGroupEvent
            self.groupEventDetailPageViewController.requestSenderId = self.requestSenderId
            
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
