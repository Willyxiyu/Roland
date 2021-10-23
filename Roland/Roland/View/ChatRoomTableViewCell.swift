//
//  ChatRoomTableViewCell.swift
//  Roland
//
//  Created by 林希語 on 2021/10/23.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellLabel()
        setUpCellButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    // MARK: - Properties
    
    var cellLabel: UILabel = {
        
        let cellLabel = UILabel()
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.font = UIFont.systemFont(ofSize: 18)
        cellLabel.textColor = UIColor.black
        cellLabel.textAlignment = .center
        
        return cellLabel
    }()
    
    lazy var deleteButton: UIButton = {
        
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.red, for: .normal)
        deleteButton.isEnabled = true
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.red.cgColor
//        deleteButton.addTarget(self, action: #selector(deleteSelectedCell), for: .touchUpInside) // for Delegate Pattern
//        deleteButton.addTarget(self, action: #selector(deleteCellwithClousure), for: .touchUpInside)
        return deleteButton
    }()
    
//    @objc func deleteCellwithClousure() {
//        deleteCellRowNumberForClosure?()
//    }
//
    

//    @objc func deleteSelectedCell(_ button: UIButton) {
//
//        delegate?.deleteSelectedCell(self, tag: button.tag)
//    }  // for Delegate Pattern
    
    func setUpCellLabel() {
        
        contentView.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.topAnchor.constraint(equalTo: self.topAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setUpCellButton() {
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
