//
//  GroupeventHomepageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/26.
//

import UIKit
import MapKit

class GroupEventHomePageViewController: UIViewController {
    
    let eventTitleList = ["wrtrt", "wrtwrtrr", "hyj7jtjf", "jrtjetheb", "aileure", "ewkuchewc", "wek.fuhefe", "ewkufhir4g", "ouri8y847yt9", "hyj7jtjf",
                          "jrtjetheb", "aileure", "hyj7jtjf", "jrtjetheb", "aileure", "hyj7jtjf", "jrtjetheb", "aileure"]
    let layout = UICollectionViewFlowLayout()
    var groupEventCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupTopView()
        setupCategorySegmentedControl()
        setupSearchTextField()
        setupAddNewEventButton()
        configureCellSize()
        groupEventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setupGroupEventCollectionView()
        groupEventCollectionView.register(GroupEventCollectionViewCell.self, forCellWithReuseIdentifier: GroupEventCollectionViewCell.identifier )
        
        groupEventCollectionView.dataSource = self
        groupEventCollectionView.delegate = self
      
        // Do any additional setup after loading the view.
    }
    
    private lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        return topView
    }()
    
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
    
    private lazy var addNewEventButton: UIButton = {
        let addNewEventButton = UIButton()
        addNewEventButton.isEnabled = true
        addNewEventButton.setImage(UIImage.init(systemName: "plus"), for: .normal)
        addNewEventButton.tintColor = UIColor.themeColor
        return addNewEventButton
    }()
    
    private func setupTopView() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func setupCategorySegmentedControl() {
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(categorySegmentedControl)
        NSLayoutConstraint.activate([
            categorySegmentedControl.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            categorySegmentedControl.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            categorySegmentedControl.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupSearchTextField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: categorySegmentedControl.topAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalTo: categorySegmentedControl.heightAnchor, multiplier: 0.7),
            searchTextField.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupAddNewEventButton() {
        addNewEventButton.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(addNewEventButton)
        NSLayoutConstraint.activate([
            addNewEventButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            addNewEventButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 5),
            addNewEventButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -5)
        ])
    }
    
    private func setupGroupEventCollectionView() {
        groupEventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(groupEventCollectionView)
        NSLayoutConstraint.activate([
            groupEventCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            groupEventCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            groupEventCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            groupEventCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
        return eventTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = groupEventCollectionView.dequeueReusableCell(withReuseIdentifier: GroupEventCollectionViewCell.identifier,
                                                                      for: indexPath) as? GroupEventCollectionViewCell else { fatalError("Error") }
        
        cell.eventTitleLabel.text = eventTitleList[indexPath.row]
        
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
    
}
