//
//  CardInfoLabel+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/21.
//

import UIKit

class CardInfoLabel: UILabel {
    
    init(labelFont: UIFont?) {
        super.init(frame: .zero)
        font = labelFont
        textColor = .white
        lineBreakMode = .byWordWrapping
        numberOfLines = 2
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
