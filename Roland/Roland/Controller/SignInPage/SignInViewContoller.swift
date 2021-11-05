//
//  LoginViewContoller.swift
//  Roland
//
//  Created by 林希語 on 2021/11/5.
//

import Foundation
import UIKit
import AuthenticationServices

class SignInViewContoller: UIViewController {
    
    let userProfileSignInViewController = UserProfileSignInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tabBarController?.tabBar.isHidden = true
        setupLogingView()
        setupLogingButton()
        setupAppIconImage()
        
    }
    
    lazy var logingView: UIView = {
        let logingView = UIView()
        logingView.backgroundColor = UIColor.themeColor
        return logingView
    }()
    
    lazy var logingButton: ASAuthorizationAppleIDButton = {
        let logingButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        logingButton.cornerRadius = 8.0
        logingButton.isEnabled = true
        logingButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        return logingButton
    }()
    
    lazy var appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
        appIconImageView.image = UIImage(named: "appicon")
        return appIconImageView
    }()
    
    @objc func appleLoginButtonTapped() {
        
        navigationController?.pushViewController(userProfileSignInViewController, animated: true)
        
        //
        //           tabBarController?.tabBar.isHidden = false
        //            UIView.animate(withDuration: 0.4) {
        //                self.logingView.alpha = 0
        //            }
    }
    
    private func setupLogingView() {
        logingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logingView)
        NSLayoutConstraint.activate([
            logingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            logingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            logingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            logingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupLogingButton() {
        logingButton.translatesAutoresizingMaskIntoConstraints = false
        logingView.addSubview(logingButton)
        NSLayoutConstraint.activate([
            logingButton.centerXAnchor.constraint(equalTo: logingView.centerXAnchor),
            logingButton.bottomAnchor.constraint(equalTo: logingView.bottomAnchor, constant: -100),
            logingButton.widthAnchor.constraint(equalTo: logingView.widthAnchor, multiplier: 0.65),
            logingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupAppIconImage() {
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        logingView.addSubview(appIconImageView)
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: logingView.centerXAnchor),
            appIconImageView.centerYAnchor.constraint(equalTo: logingView.centerYAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 50),
            appIconImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
