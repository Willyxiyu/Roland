//
//  CardImageView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/21.
//

import UIKit

class CardImageView: UIImageView {
   init() {
       super.init(frame: .zero)
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        image = UIImage(named: "PS5")
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
