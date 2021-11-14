//
//  GroupEventCEPETimeVC.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import Foundation
import UIKit

class GroupEventCEPETimeVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let groupEventCEPELocationVC = GroupEventCEPELocationVC()
    
    var eventTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setBackgroundImage(imageName: "CEBGVertical")
        self.view.backgroundColor = .white

        setupQuestionView()
        setupEventStartLabel()
        setupEventEndLabel()
        setupEventStartDatePicker()
        setupEventEndDatePicker()
        setupContinueButton()
        setupStepLabel()
        setupQuestionLabel()
        setupIntroLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        tabBarController?.tabBar.isHidden = false
    //    }
    
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
        stepLabel.text = "Step 2 of 6"
        stepLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        stepLabel.textAlignment = .left
        stepLabel.lineBreakMode = .byWordWrapping
        stepLabel.numberOfLines = 0
        return stepLabel
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.textColor = UIColor.black
        questionLabel.text = "活動時間?"
        questionLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        return questionLabel
    }()
    
    private lazy var introLabel: UILabel = {
        let introLabel = UILabel()
        introLabel.textColor = UIColor.lightGray
        introLabel.text = "三更苦淚流，歲月幾時逢摯友"
        introLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        introLabel.textAlignment = .left
        introLabel.lineBreakMode = .byWordWrapping
        introLabel.numberOfLines = 0
        return introLabel
    }()
    
    private lazy var eventStartLabel: UILabel = {
        let eventStartLabel = UILabel()
        eventStartLabel.text = "活動開始時間"
        eventStartLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return eventStartLabel
    }()
    
    private lazy var eventEndLabel: UILabel = {
        let eventEndLabel = UILabel()
        eventEndLabel.text = "活動結束時間"
        eventEndLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return eventEndLabel
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
        
        let startDate = eventStartDatePicker.date
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "yyyy.MM.dd h:mm"
        let startTime = startDateFormatter.string(from: startDate)
        let endDate = eventEndDatePicker.date
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "yyyy.MM.dd h:mm"
        let endTime = endDateFormatter.string(from: endDate)
        
        groupEventCEPELocationVC.eventTitle = eventTitle
        groupEventCEPELocationVC.startTime = startTime
        groupEventCEPELocationVC.endTime = endTime
        navigationController?.pushViewController(groupEventCEPELocationVC, animated: true)
    }
    private lazy var eventStartDatePicker: UIDatePicker = {
        let eventStartDatePicker = UIDatePicker()
        eventStartDatePicker.datePickerMode = .dateAndTime
        eventStartDatePicker.minuteInterval = 15
        eventStartDatePicker.date = Date()
        let formatter = DateFormatter()
        let fromDateTime = formatter.date(from: "1994-12-13 12:13")
        eventStartDatePicker.minimumDate = fromDateTime
        return eventStartDatePicker
    }()
    private lazy var eventEndDatePicker: UIDatePicker = {
        let eventEndDatePicker = UIDatePicker()
        eventEndDatePicker.datePickerMode = .dateAndTime
        eventEndDatePicker.minuteInterval = 15
        eventEndDatePicker.date = Date()
        let formatter = DateFormatter()
        let fromDateTime = formatter.date(from: "1994-12-13 12:13")
        eventEndDatePicker.minimumDate = fromDateTime
        return eventEndDatePicker
    }()

    private func setupQuestionView() {
        questionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionView)
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            questionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupEventStartLabel() {
        eventStartLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(eventStartLabel)
        NSLayoutConstraint.activate([
            eventStartLabel.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 60),
            eventStartLabel.leadingAnchor.constraint(equalTo: questionView.leadingAnchor)
        ])
    }
    
    private func setupEventEndLabel() {
        eventEndLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(eventEndLabel)
        NSLayoutConstraint.activate([
            eventEndLabel.topAnchor.constraint(equalTo: eventStartLabel.bottomAnchor, constant: 30),
            eventEndLabel.leadingAnchor.constraint(equalTo: eventStartLabel.leadingAnchor)
        ])
    }
    
    private func setupContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: eventEndLabel.bottomAnchor, constant: 100),
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
    
    private func setupEventStartDatePicker() {
        eventStartDatePicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(eventStartDatePicker)
        NSLayoutConstraint.activate([
            eventStartDatePicker.centerYAnchor.constraint(equalTo: eventStartLabel.centerYAnchor),
            eventStartDatePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            eventStartDatePicker.heightAnchor.constraint(equalTo: eventStartLabel.heightAnchor)
        ])
    }
    
    private func setupEventEndDatePicker() {
        eventEndDatePicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(eventEndDatePicker)
        NSLayoutConstraint.activate([
            eventEndDatePicker.centerYAnchor.constraint(equalTo: eventEndLabel.centerYAnchor),
            eventEndDatePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            eventEndDatePicker.heightAnchor.constraint(equalTo: eventEndLabel.heightAnchor)
        ])
    }
}
