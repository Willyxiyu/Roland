//
//  UIView+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

extension UIView {
    
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 10
    }
    
}
