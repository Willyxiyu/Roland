//
//  TabBarController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/19.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.imageInsets = UIEdgeInsets(top: 50, left: 0, bottom: -10, right: 0)
    }
}
