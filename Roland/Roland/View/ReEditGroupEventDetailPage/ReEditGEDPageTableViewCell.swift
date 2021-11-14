//
//  ReEditGEDPageTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/11/13.
//

import UIKit

protocol DetailPageCellDelegate: AnyObject {
    
    func titleUpdate(title: String)
    
    func locationUpdate(location: String)
    
    func MOPeopleUpdate(MOP: String)
}

protocol DetailPageDatePickerCellDelegate: AnyObject {
    
    func stimeUpdate(startTime: String)
    
    func etimeUpdate(endTime: String)
    
}

enum DetailPageInfoCell {
    
    case titleUpdateCell
    
    case locationUpdateCell
    
    case MOPeopleUpdateCell
}

class ReEditGEDPageTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - PhotoCell
class ReEditGEPhotoCell: UITableViewCell {
    
    var addNewPhoto: (() -> Void)?
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPhotoImageView()
        setupEventImageButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    lazy var eventImageButton: UIButton = {
        let eventImageButton = UIButton()
        eventImageButton.setImage(UIImage(named: "camera"), for: .normal)
        eventImageButton.layer.masksToBounds = true
        eventImageButton.alpha = 0.7
        eventImageButton.addTarget(self, action: #selector(eventImageButtonTapped), for: .touchUpInside)
        return eventImageButton
    }()
    
    @objc func eventImageButtonTapped() {
        addNewPhoto?()
        
    }
    private func setupPhotoImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 9 / 16)
        ])
    }
    
    private func setupEventImageButton() {
        eventImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventImageButton)
        NSLayoutConstraint.activate([
            eventImageButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            eventImageButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            eventImageButton.heightAnchor.constraint(equalToConstant: 20),
            eventImageButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
// MARK: - TitleCell

class ReEditGECell: UITableViewCell {
    
    weak var delegate: DetailPageCellDelegate?
    
    var updateInfo: DetailPageInfoCell = .titleUpdateCell
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        setupTextField()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.clear
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(editEnd), for: .editingChanged)
        return textField
    }()
    
    @objc func editEnd() {
        
        guard let text = textField.text else {
            fatalError("error")
        }
        
        switch updateInfo {
            
        case .titleUpdateCell:
            
            delegate?.titleUpdate(title: text)
            
        case .locationUpdateCell:
            
            delegate?.locationUpdate(location: text)
            
        case .MOPeopleUpdateCell:
            
            delegate?.MOPeopleUpdate(MOP: text)
            
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
        ])
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            textField.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.6),
            textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - DetailCell
class ReEditGETimeCell: UITableViewCell {
    
    weak var delegate: DetailPageDatePickerCellDelegate?
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStartLabel()
        setupEventStartDatePicker()
        setupEndLabel()
        setupEventEndDatePicker()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var startLabel: UILabel = {
        let startLabel = UILabel()
        startLabel.textColor = UIColor.black
        startLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        startLabel.textAlignment = .left
        startLabel.text = "活動開始時間"
        return startLabel
    }()
    
    lazy var endLabel: UILabel = {
        let endLabel = UILabel()
        endLabel.textColor = UIColor.black
        endLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        endLabel.textAlignment = .left
        endLabel.text = "活動結束時間"
        return endLabel
    }()
    
    lazy var eventStartDatePicker: UIDatePicker = {
        let eventStartDatePicker = UIDatePicker()
        eventStartDatePicker.datePickerMode = .dateAndTime
        eventStartDatePicker.minuteInterval = 15
        eventStartDatePicker.date = Date()
        let formatter = DateFormatter()
        let fromDateTime = formatter.date(from: "1994-12-13 12:13")
        eventStartDatePicker.minimumDate = fromDateTime
        eventStartDatePicker.addTarget(self, action: #selector(editSTime), for: .valueChanged)
        return eventStartDatePicker
    }()
    
    @objc func editSTime() {
        let startDate = eventStartDatePicker.date
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "yyyy.MM.dd h:mm"
        let startTime = startDateFormatter.string(from: startDate)
        delegate?.stimeUpdate(startTime: startTime)
    }
    
    lazy var eventEndDatePicker: UIDatePicker = {
        let eventEndDatePicker = UIDatePicker()
        eventEndDatePicker.datePickerMode = .dateAndTime
        eventEndDatePicker.minuteInterval = 15
        eventEndDatePicker.date = Date()
        let formatter = DateFormatter()
        let fromDateTime = formatter.date(from: "1994-12-13 12:13")
        eventEndDatePicker.minimumDate = fromDateTime
        eventEndDatePicker.addTarget(self, action: #selector(editETime), for: .valueChanged)
        return eventEndDatePicker
    }()
    
    @objc func editETime() {
        let endDate = eventEndDatePicker.date
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "yyyy.MM.dd h:mm"
        let endTime = endDateFormatter.string(from: endDate)
        delegate?.etimeUpdate(endTime: endTime)
    }
    
    private func setupStartLabel() {
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(startLabel)
        NSLayoutConstraint.activate([
            startLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            startLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20)
        ])
    }
    
    private func setupEndLabel() {
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(endLabel)
        NSLayoutConstraint.activate([
            endLabel.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            endLabel.topAnchor.constraint(equalTo: eventStartDatePicker.bottomAnchor, constant: 15)
        ])
    }
    
    private func setupEventStartDatePicker() {
        eventStartDatePicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventStartDatePicker)
        NSLayoutConstraint.activate([
            eventStartDatePicker.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 10),
            eventStartDatePicker.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor)
        ])
    }
    
    private func setupEventEndDatePicker() {
        eventEndDatePicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventEndDatePicker)
        NSLayoutConstraint.activate([
            eventEndDatePicker.leadingAnchor.constraint(equalTo: eventStartDatePicker.leadingAnchor),
            eventEndDatePicker.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 10),
            eventEndDatePicker.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - TitleCell

class ReEditGEIntroCell: UITableViewCell, UITextViewDelegate {
        
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textView.textAlignment = .left
        textView.layer.borderWidth = 1
        textView.isEditable = true
        textView.isSelectable = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        return textView
    }()
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
        ])
    }
    
    private func setupTextView() {
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            textView.heightAnchor.constraint(equalToConstant: 100),
            textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
}
