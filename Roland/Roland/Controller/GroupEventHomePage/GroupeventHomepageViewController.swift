//
//  GroupeventHomepageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/26.
//

import UIKit
import MapKit

class GroupEventHomePageViewController: UIViewController {
    
    let groupEventCEPViewController = GroupEventCEPENameVC()
    let groupEventDetailPageViewController = GroupEventDetailPageViewController()
    
    let layout = UICollectionViewFlowLayout()
    var groupEventCollectionView: UICollectionView!
    var groupEvent = [GroupEvent]() {
        
        didSet {
            
            groupEventCollectionView.reloadData()
            
            print(groupEvent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupCategorySegmentedControl()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(createNewEvent))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.themeColor
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
    private lazy var categorySegmentedControl: UISegmentedControl = {
        let categorySegmentedControl = UISegmentedControl(items: ["Top", "Recent"])
        categorySegmentedControl.tintColor = UIColor.blue
        categorySegmentedControl.backgroundColor = UIColor.themeColor
        categorySegmentedControl.selectedSegmentIndex = 0
        return categorySegmentedControl
    }()
    
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.setLeftPaddingPoints(10)
        searchTextField.backgroundColor = UIColor.secondThemeColor
        searchTextField.placeholder = "search a fun event!"
        searchTextField.borderStyle = .roundedRect
        return searchTextField
    }()
    
    @objc private func createNewEvent() {
        navigationController?.pushViewController(groupEventCEPViewController, animated: true)
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
            groupEventCollectionView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor),
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
        
        cell.eventTitleLabel.text = self.groupEvent[indexPath.row].title
        cell.eventLocationLabel.text = self.groupEvent[indexPath.row].location
        cell.eventDateLabel.text = self.groupEvent[indexPath.row].startTime
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.view.frame.size.width) / 2 - 15), height: ((self.view.frame.size.width) / 2 + 20))
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
        
        groupEventDetailPageViewController.selectedGroupEvent = selectedGroupEvent
        
        navigationController?.pushViewController(groupEventDetailPageViewController, animated: true)
    }
    
}
