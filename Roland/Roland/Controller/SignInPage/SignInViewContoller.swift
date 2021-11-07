//
//  LoginViewContoller.swift
//  Roland
//
//  Created by 林希語 on 2021/11/5.
//

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit

class SignInViewContoller: UIViewController {
    
    let userProfileSignInViewController = UserProfileSignInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tabBarController?.tabBar.isHidden = true
        setupLogingView()
        setupLogingButton()
        setupAppIconImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        performSignIn()
        navigationController?.pushViewController(userProfileSignInViewController, animated: true)

    }
    
    func performSignIn() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
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
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

extension SignInViewContoller: ASAuthorizationControllerDelegate {
    
}

extension SignInViewContoller: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let window =  self.view.window else {
            fatalError("error")
        }
        
        return window
    }
    
}
