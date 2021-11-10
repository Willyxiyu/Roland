//
//  CardImageView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/21.
//

import UIKit
import Kingfisher

class CardImageView: UIImageView {
   init() {
       super.init(frame: .zero)
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
