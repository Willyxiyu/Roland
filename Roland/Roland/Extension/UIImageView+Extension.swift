//
//  UIImageView+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit
extension UIImageView {

    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }

}
