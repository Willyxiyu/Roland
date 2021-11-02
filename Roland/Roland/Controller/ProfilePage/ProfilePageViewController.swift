//
//  ProfilePageViewController.swift
//  
//
//  Created by 林希語 on 2021/10/31.
//

import Foundation
import UIKit
import Lottie

class ProfilePageViewController: UIViewController {
    let animationView = AnimationView(name: "72933-likelove-icon-micro-interaction")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage(imageName: "profilePic")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupAnimation()
    }
    
    func setupAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        view.addSubview(animationView)
        animationView.play()
    }
    
}
