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
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 30, width: Int(self.view.frame.width), height: Int(self.view.frame.height) - 30 ))
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
