//
//  MeetUpFilterViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/9.
//

import UIKit
import MultiSlider

class MeetUpFilterViewController: UIViewController {
    
    var favoriteGender = "全部" {
        
        didSet {
            
            print(favoriteGender)
        }
        
    }
    
    var ageArrangeString = ["20", "30"] {
        
        didSet {
            
            print(ageArrangeString)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closeFilter))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setupLikeLabel()
        setupFilterSegmentedControl()
        setupAgeLabel()
        setupSliderView()
        setupHorizontalMultiSlider()
        setupConfirmButton()
        setupBorderLineView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        confirmButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 15
       
    }
    
    @objc func closeFilter() {
        self.navigationController?.popToRootViewController(animated: true)
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
        filterSegmentedControl.selectedSegmentIndex = 2
        filterSegmentedControl.clipsToBounds = true
        filterSegmentedControl.addTarget(self, action: #selector(onChange), for: .valueChanged)
        return filterSegmentedControl
    }()
    
    @objc func onChange(sender: UISegmentedControl) {
            
        if let selectedIndex = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            
            favoriteGender = selectedIndex
                    
        }
        
    }
    
    lazy var horizontalMultiSlider: MultiSlider = {
        let horizontalMultiSlider = MultiSlider()
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.minimumValue = 18
        horizontalMultiSlider.maximumValue = 101
        horizontalMultiSlider.outerTrackColor = .lightGray
        horizontalMultiSlider.value = [20, 30]
        horizontalMultiSlider.valueLabelPosition = .top
        horizontalMultiSlider.tintColor = .themeColor
        horizontalMultiSlider.trackWidth = 3
        horizontalMultiSlider.snapStepSize = 1
        horizontalMultiSlider.isHapticSnap = false
        horizontalMultiSlider.showsThumbImageShadow = false
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        //        view.addConstrainedSubview(horizontalMultiSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
        //        view.layoutMargins = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
        
        //    multiSlider.keepsDistanceBetweenThumbs = false
        horizontalMultiSlider.keepsDistanceBetweenThumbs = true
        horizontalMultiSlider.valueLabelFormatter.positiveSuffix = " y"
        horizontalMultiSlider.valueLabelColor = .themeColor
        horizontalMultiSlider.valueLabelFont = UIFont.italicSystemFont(ofSize: 12)
        
        //        if #available(iOS 13.0, *) {
        //            horizontalMultiSlider.minimumImage = UIImage(systemName: "scissors")
        //            horizontalMultiSlider.maximumImage = UIImage(systemName: "paperplane.fill")
        //        }
        
        return horizontalMultiSlider
    }()
    
    @objc func sliderChanged() {
        
        let result = horizontalMultiSlider.value
            
        var intResult: [Int] = []
        for iiii in result {
            let jjjj = Int(iiii)
            intResult.append(jjjj)
            
        }
            
        var ageArrangeString: [String] = []
        for sss in intResult {
            let ooo = String(sss)
            ageArrangeString.append(ooo)
            
        }
        
        self.ageArrangeString = ageArrangeString
                
    }
    
    lazy var sliderView: UIView = {
        let sliderView = UIView()
        sliderView.backgroundColor = .clear
        return sliderView
    }()
    
    lazy var borderLineView: UIView = {
        let borderLineView = UIView()
        borderLineView.backgroundColor = .lightGray
        return borderLineView
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.setTitle("確認", for: .normal)
        confirmButton.backgroundColor = UIColor.themeColor
        confirmButton.isEnabled = true
        confirmButton.addTarget(self, action: #selector(sendRequestandCloseFilter), for: .touchUpInside)
        return confirmButton
    }()
    
    @objc func sendRequestandCloseFilter() {
        
        // 數字若到100就不會算到
        
        FirebaseManger.shared.fetchUserInfobyFilterResult(gender: favoriteGender, minAge: ageArrangeString[0], maxAge: ageArrangeString[1]) { userInfo in
            
            guard let rootvc = self.navigationController?.viewControllers[0] as? CardPageViewController else { return }
            
            // 先讓cardpage的卡片消失，再用篩選器找到的結果，轉成卡片。
            rootvc.cardView.subviews.forEach { $0.removeFromSuperview() }
            
            userInfo.forEach { (userInfo) in
                                
                rootvc.setupCard(CardView(user: userInfo))
            }
            
//            rootvc.useFilter = true
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    private func setupLikeLabel() {
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeLabel)
        NSLayoutConstraint.activate([
            likeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            likeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50)
        ])
    }
    
    private func setupFilterSegmentedControl() {
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterSegmentedControl)
        NSLayoutConstraint.activate([
            filterSegmentedControl.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 20),
            filterSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            filterSegmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    private func setupAgeLabel() {
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 50),
            ageLabel.leadingAnchor.constraint(equalTo: likeLabel.leadingAnchor)
        ])
    }
    
    private func setupHorizontalMultiSlider() {
        horizontalMultiSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalMultiSlider)
        NSLayoutConstraint.activate([
            horizontalMultiSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            horizontalMultiSlider.widthAnchor.constraint(equalTo: filterSegmentedControl.widthAnchor),
            horizontalMultiSlider.heightAnchor.constraint(equalToConstant: 40),
            horizontalMultiSlider.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor)
        ])
    }
    
    private func setupSliderView() {
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sliderView)
        NSLayoutConstraint.activate([
            sliderView.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 30),
            sliderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            sliderView.widthAnchor.constraint(equalTo: filterSegmentedControl.widthAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupConfirmButton() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBorderLineView() {
        borderLineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderLineView)
        NSLayoutConstraint.activate([
            borderLineView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            borderLineView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),
            borderLineView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            borderLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}
