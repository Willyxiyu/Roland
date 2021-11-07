//
//  UserProfileSignInTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/11/5.
//

import UIKit

class UserProfileSignInTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

}

// user photo
class UserProfilePhotoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemGray5
        setupView()
        setupUserPhotoImageView()
        setupChangePhotoButton()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.cornerRadius = UIScreen.main.bounds.width / 4
        userPhotoImageView.layer.masksToBounds = true
        userPhotoImageView.layer.cornerRadius = UIScreen.main.bounds.width / 4
        
    }
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        return view
    }()
    
    lazy var userPhotoImageView: UIImageView = {
        let userPhotoImageView = UIImageView()
        userPhotoImageView.tintColor = .white
        userPhotoImageView.contentMode = .scaleAspectFill
        userPhotoImageView.clipsToBounds = true

        return userPhotoImageView
    }()
    
    lazy var changePhotoButton: UIButton = {
        let changePhotoButton = UIButton()
        changePhotoButton.setTitle("Change Photo", for: .normal)
        changePhotoButton.setTitleColor(UIColor.themeColor, for: .normal)
        return changePhotoButton
    }()
    
    private func setupUserPhotoImageView() {
        userPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userPhotoImageView)
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 50),
            userPhotoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -50),
            userPhotoImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            userPhotoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupChangePhotoButton() {
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(changePhotoButton)
        NSLayoutConstraint.activate([
            changePhotoButton.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 25),
            changePhotoButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            changePhotoButton.centerXAnchor.constraint(equalTo: userPhotoImageView.centerXAnchor)
        
        ])
    }
    
    private func setupView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 50),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -50),
            view.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            view.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
    }
}

// user name & email address
class UserProfileNameEmailTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserNameEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var userNameEmailTextField: UITextField = {
        let userNameEmailTextField = UITextField()
        userNameEmailTextField.textColor = UIColor.black
        userNameEmailTextField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        userNameEmailTextField.setLeftPaddingPoints(15)
        return userNameEmailTextField
    }()
    
    private func setupUserNameEmailLabel() {
        userNameEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userNameEmailTextField)
        NSLayoutConstraint.activate([
            userNameEmailTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            userNameEmailTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            userNameEmailTextField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            userNameEmailTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            userNameEmailTextField.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

// first part intro word
class UserProfileFirstIntroTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemGray6
        setupIntrolLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var introLabel: UILabel = {
        let introLabel = UILabel()
        introLabel.textColor = UIColor.black
        introLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        introLabel.textAlignment = .left
        introLabel.numberOfLines = 0
        introLabel.lineBreakMode = .byWordWrapping
        return introLabel
    }()
    
    private func setupIntrolLabel() {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(introLabel)
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            introLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
            introLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            introLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }

}

// age
class UserProfileAgeTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
  
    let age: [String] = {
        var array = ["Not set"]
        for agerange in 18...101 {
            array.append("\(agerange)")
        }
        return array
    }()
    
    let pickerView = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return age.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return age[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = age[row]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAgeLabel()
        setupAgeTextField()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var ageLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.textColor = UIColor.gray
        ageLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        ageLabel.textAlignment = .left
        ageLabel.text = "Age"
        return ageLabel
    }()
    
    lazy var ageTextField: UITextField = {
        let ageTextField = UITextField()
        ageTextField.inputView = pickerView
        ageTextField.tag = 1
        return ageTextField
    }()
    
    private func setupAgeLabel() {
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            ageLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),
            ageLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupAgeTextField() {
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(ageTextField)
        NSLayoutConstraint.activate([
            ageTextField.leadingAnchor.constraint(equalTo: ageLabel.leadingAnchor),
            ageTextField.topAnchor.constraint(equalTo: ageLabel.bottomAnchor),
            ageTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            ageTextField.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        
        ])
    }
}

// gender
class UserProfileGenderTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let gender = [ "Prefer not to say", "Female", "Male", "Nonbinary"]
    
    let pickerView = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = gender[row]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGenderLabel()
        setupGenderTextField()
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var genderLabel: UILabel = {
        let genderLabel = UILabel()
        genderLabel.textColor = UIColor.gray
        genderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        genderLabel.textAlignment = .left
        genderLabel.text = "Gender"
        return genderLabel
    }()
    
    lazy var genderTextField: UITextField = {
        let genderTextField = UITextField()
        genderTextField.inputView = pickerView
        genderTextField.tag = 2
        return genderTextField
    }()
    
    private func setupGenderLabel() {
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(genderLabel)
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            genderLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            genderLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGenderTextField() {
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(genderTextField)
        NSLayoutConstraint.activate([
            genderTextField.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor),
            genderTextField.topAnchor.constraint(equalTo: genderLabel.bottomAnchor),
            genderTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            genderTextField.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        
        ])
    }
}

// second part intro word
class UserProfileSecondIntroTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemGray6
        setupIntrolLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    lazy var introLabel: UILabel = {
        let introLabel = UILabel()
        introLabel.textColor = UIColor.black
        introLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        introLabel.textAlignment = .left
        introLabel.numberOfLines = 0
        introLabel.lineBreakMode = .byWordWrapping
        return introLabel
    }()
    
    private func setupIntrolLabel() {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(introLabel)
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            introLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
            introLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            introLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
}
