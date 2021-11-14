//
//  CardInfoLabel+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/21.
//

import UIKit

class CardInfoLabel: UILabel {
    
    init(frame: CGRect, labelText: String, labelColor: UIColor) {
        super.init(frame: frame)
        font = .boldSystemFont(ofSize: 45)
        text = labelText
        textColor = labelColor
        layer.borderWidth = 3
        layer.borderColor = labelColor.cgColor
        layer.cornerRadius = 10
        
        textAlignment = .center
        alpha = 0
        
    }
    
    init(frame: CGRect, labelText: String, labelFont: UIFont) {
        super.init(frame: frame)
        font = labelFont
        textColor = .white
        text = labelText
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
