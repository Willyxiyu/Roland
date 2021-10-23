//
//  ChatroomlistViewController.swift
//  
//
//  Created by 林希語 on 2021/10/22.
//

import UIKit

class ChatroomlistViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = .brown
    }
    
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "搜尋"
        searchTextField.backgroundColor = UIColor.secondThemeColor
        searchTextField.returnKeyType = .done
        searchTextField.setLeftPaddingPoints(10)
        return searchTextField
    }()
}
