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
import FirebaseAuth

class SignInViewContoller: UIViewController {
    
    let userProfileSignInViewController = UserProfileSignInViewController()
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.themeColor
        setupLogingButton()
        setupAppIconImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    lazy var logingButton: ASAuthorizationAppleIDButton = {
        let logingButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        logingButton.cornerRadius = 8.0
        logingButton.isEnabled = true
        logingButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        return logingButton
    }()
    
    lazy var appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
        appIconImageView.image = UIImage(named: "rolandicon")
        appIconImageView.contentMode = .scaleAspectFit
        appIconImageView.clipsToBounds = true
        return appIconImageView
    }()
    
    @objc func appleLoginButtonTapped() {
        
        performSignIn()
        
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
    
    private func setupLogingButton() {
        logingButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logingButton)
        NSLayoutConstraint.activate([
            logingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logingButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            logingButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.65),
            logingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupAppIconImage() {
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appIconImageView)
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            appIconImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            appIconImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2),
            appIconImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
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
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (_, error) in
                if let error = error {
                    
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    
                } else {
                    
                    if let name = appleIDCredential.fullName?.givenName,
                       let email = appleIDCredential.email {
                            
                        FirebaseManger.shared.postNewUserInfo(name: name, gender: "", age: "", photo: "", email: email)
                    }
                    // User is signed in to Firebase with Apple.
                    // ...
                    FirebaseManger.shared.fetchUserInfobyUserId { result in
                        self.userInfo = result
                    }
                    
                    if self.userInfo?.name.isEmpty == true {
                        
                        let nav = UINavigationController(rootViewController: self.userProfileSignInViewController)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                        
                    } else {
                        
                        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
                        
                        guard let tabBarVC = tabBarVC as? TabBarViewController else { return }
                        tabBarVC.modalPresentationStyle = .fullScreen
                        self.show(tabBarVC, sender: nil)
                    }

                }
                return
            }
            
            func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                // Handle error.
                print("Sign in with Apple errored: \(error)")
            }
        }
        
    }
    
}

extension SignInViewContoller: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let window =  self.view.window else {
            fatalError("error")
        }
        
        return window
    }
    
}
