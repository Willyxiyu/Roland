//
//  NotReadyPageViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/18.
//

import UIKit

class NotReadyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupSettingPageTitleLabel()
        setupCloseSettingPageButton()
        // Do any additional setup after loading the view.
    }
    
    lazy var settingPageTitleLabel: UILabel = {
        let settingPageTitleLabel = UILabel()
        settingPageTitleLabel.text = "建置中..."
        settingPageTitleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        settingPageTitleLabel.textAlignment = .center
        
        return settingPageTitleLabel
    }()
    
    lazy var closeSettingPageButton: UIButton = {
        let closeSettingPageButton = UIButton()
        closeSettingPageButton.setBackgroundImage(UIImage.init(systemName: "x.circle"), for: .normal)
        closeSettingPageButton.tintColor = .black
        closeSettingPageButton.addTarget(self, action: #selector(closeSettingPage), for: .touchUpInside)
        return closeSettingPageButton
    }()
    
    @objc func closeSettingPage() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupSettingPageTitleLabel() {
        settingPageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(settingPageTitleLabel)
        NSLayoutConstraint.activate([
            settingPageTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            settingPageTitleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
    
    private func setupCloseSettingPageButton() {
        closeSettingPageButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeSettingPageButton)
        NSLayoutConstraint.activate([
            closeSettingPageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35),
            closeSettingPageButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeSettingPageButton.heightAnchor.constraint(equalToConstant: 30),
            closeSettingPageButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
   
}
