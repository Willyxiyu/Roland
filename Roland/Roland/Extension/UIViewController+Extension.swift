//
//  UIViewController+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

extension UIViewController {
    func setBackgroundImage(imageName: String) {
        let backgroundImage = UIImage(named: imageName)
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
}
