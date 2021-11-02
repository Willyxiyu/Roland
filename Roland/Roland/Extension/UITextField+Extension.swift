//
//  UITextField+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/22.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setBottomBorder() {
           self.borderStyle = .none
           self.layer.backgroundColor = UIColor.white.cgColor
           
           self.layer.masksToBounds = false
           self.layer.shadowColor = UIColor.gray.cgColor
           self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
           self.layer.shadowOpacity = 1.0
           self.layer.shadowRadius = 0.0
       }
    
}
