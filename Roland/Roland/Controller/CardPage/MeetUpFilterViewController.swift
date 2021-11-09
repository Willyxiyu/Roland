//
//  MeetUpFilterViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/9.
//

import UIKit

class MeetUpFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "篩選器"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closeFilter))
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(shareNewEvent))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setupLikeLabel()
        setupFilterSegmentedControl()
        setupAgeLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func closeFilter() {
        self.navigationController?.popToRootViewController(animated: true)
//        navigationController?.popViewController(animated: true)
    }
    
    let filterArray = ["我喜歡...", "年齡", "進階"]

    lazy var likeLabel: UILabel = {
        let likeLabel = UILabel()
        likeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        likeLabel.text = filterArray[0]
        return likeLabel
    }()
    
    lazy var ageLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        ageLabel.text = filterArray[1]
        return ageLabel
    }()
    
    lazy var moreFilterLabel: UILabel = {
        let moreFilterLabel = UILabel()
        moreFilterLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        moreFilterLabel.text = filterArray[2]
        return moreFilterLabel
    }()
    
    lazy var filterSegmentedControl: UISegmentedControl = {
        let filterSegmentedControl = UISegmentedControl(items: ["男性", "女性", "全部"])
        filterSegmentedControl.tintColor = UIColor.themeColor
        filterSegmentedControl.selectedSegmentIndex = 0
        return filterSegmentedControl
    }()
    
    private func setupLikeLabel() {
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeLabel)
        NSLayoutConstraint.activate([
            likeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            likeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            likeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func setupFilterSegmentedControl() {
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterSegmentedControl)
        NSLayoutConstraint.activate([
            filterSegmentedControl.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 10),
            filterSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            filterSegmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        
        ])
    }
    
    private func setupAgeLabel() {
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 20),
            ageLabel.leadingAnchor.constraint(equalTo: likeLabel.leadingAnchor)
        ])
    }

}
