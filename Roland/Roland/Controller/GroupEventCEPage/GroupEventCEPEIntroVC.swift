//
//  GroupEventCEPEIntroVC.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import Foundation
import UIKit

class GroupEventCEPEIntroVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITextPasteDelegate {
    
    let groupEventCEPFEPVC = GroupEventCEPFEPVC()
    var eventTitle = String()
    var startTime = String()
    var endTime = String()
    var eventLocation = String()
    var maxPeople = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        setupQuestionView()
        setupTextView()
        setupContinueButton()
        setupStepLabel()
        setupQuestionLabel()
        setupIntroLabel()
//        self.textView.pasteDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var questionView: UIView = {
        let questionView = UIView()
        questionView.backgroundColor = .white
        questionView.layer.cornerRadius = 10
        questionView.setShadow()
        return questionView
    }()
    
    private lazy var stepLabel: UILabel = {
        let stepLabel = UILabel()
        stepLabel.textColor = UIColor.red
        stepLabel.text = "Step 5 of 6"
        stepLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        stepLabel.textAlignment = .left
        stepLabel.lineBreakMode = .byWordWrapping
        stepLabel.numberOfLines = 0
        return stepLabel
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.textColor = UIColor.black
        questionLabel.text = "活動簡介?"
        questionLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        return questionLabel
    }()
    
    private lazy var introLabel: UILabel = {
        let introLabel = UILabel()
        introLabel.textColor = UIColor.lightGray
        introLabel.text = "橫看成嶺側成峰 遠近高低各不同."
        introLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        introLabel.textAlignment = .left
        introLabel.lineBreakMode = .byWordWrapping
        introLabel.numberOfLines = 0
        return introLabel
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textView.textAlignment = .left
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
        textView.isSelectable = true
        return textView
    }()
    
    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.backgroundColor = UIColor.black
        continueButton.addTarget(self, action: #selector(continueNextPage), for: .touchUpInside)
        return continueButton
    }()
    
    @objc func continueNextPage() {
        
        guard let eventIntro = textView.text else { return }
        
        groupEventCEPFEPVC.eventTitle = eventTitle
        groupEventCEPFEPVC.startTime = startTime
        groupEventCEPFEPVC.endTime = endTime
        groupEventCEPFEPVC.eventLocation = eventLocation
        groupEventCEPFEPVC.maxPeople = Int(maxPeople)
        groupEventCEPFEPVC.eventIntro = eventIntro
        navigationController?.pushViewController(groupEventCEPFEPVC, animated: true)
    }
    
    private func setupQuestionView() {
        questionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionView)
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            questionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupTextView() {
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 20),
            textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            textView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 100),
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
}
