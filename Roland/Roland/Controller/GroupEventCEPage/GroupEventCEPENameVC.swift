//
//  GroupEventCEPViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

class GroupEventCEPENameVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let groupEventCEPETimeVC = GroupEventCEPETimeVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondThemeColor
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backButtonTitle = ""
        
        setupQuestionView()
        setUpTextFiled()
        setupContinueButton()
        setupStepLabel()
        setupQuestionLabel()
        setupIntroLabel()
        setupBottomLineView()
        textField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .lightGray
        return bottomLineView
    }()
    
    private lazy var questionView: UIView = {
        let questionView = UIView()
        questionView.backgroundColor = .white
        questionView.layer.cornerRadius = 10
        questionView.setShadow()
        return questionView
    }()
    
    private lazy var stepLabel: UILabel = {
        let stepLabel = UILabel()
        stepLabel.textColor = UIColor.themeColor
        stepLabel.text = "Step 1 of 6"
        stepLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        stepLabel.textAlignment = .left
        stepLabel.lineBreakMode = .byWordWrapping
        stepLabel.numberOfLines = 0
        return stepLabel
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.textColor = UIColor.black
        questionLabel.text = "你的活動名稱是什麼?"
        questionLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        return questionLabel
    }()
    
    private lazy var introLabel: UILabel = {
        let introLabel = UILabel()
        introLabel.textColor = UIColor.lightGray
        introLabel.text = "如此一來，我們才能幫你建立活動."
        introLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        introLabel.textAlignment = .left
        introLabel.lineBreakMode = .byWordWrapping
        introLabel.numberOfLines = 0
        return introLabel
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "活動名稱"
        textField.backgroundColor = UIColor.clear
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor.black
        continueButton.addTarget(self, action: #selector(continueNextPage), for: .touchUpInside)
        continueButton.isEnabled = false
        continueButton.setTitleColor(.gray, for: .normal)
        return continueButton
    }()
    
    @objc func continueNextPage() {
        
        guard let eventTitle = textField.text else { return }
        groupEventCEPETimeVC.eventTitle = eventTitle
        navigationController?.pushViewController(groupEventCEPETimeVC, animated: true)
        
    }
    
    private func setupQuestionView() {
        questionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionView)
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            questionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            questionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setUpTextFiled() {
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 30),
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: questionView.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        textField.delegate = self
    }
    
    private func setupContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 100),
            continueButton.widthAnchor.constraint(equalTo: questionView.widthAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.centerXAnchor.constraint(equalTo: questionView.centerXAnchor)
        ])
    }
    
    private func setupStepLabel() {
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(stepLabel)
        NSLayoutConstraint.activate([
            stepLabel.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 20),
            stepLabel.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 15)
        ])
    }
    private func setupQuestionLabel() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 25),
            questionLabel.leadingAnchor.constraint(equalTo: stepLabel.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -15)
        ])
    }
    private func setupIntroLabel() {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(introLabel)
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 15),
            introLabel.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            introLabel.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -15),
            introLabel.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupBottomLineView() {
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomLineView)
        NSLayoutConstraint.activate([
            bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            bottomLineView.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            bottomLineView.widthAnchor.constraint(equalTo: textField.widthAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.isEmpty == true {
            
            continueButton.isEnabled = false
            continueButton.setTitleColor(.gray, for: .normal)
            
        } else if textField.text?.isEmpty == false {
            
            continueButton.isEnabled = true
            continueButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        continueButton.isEnabled = false
        continueButton.setTitleColor(.gray, for: .normal)
        
    }
    
}
