//
//  CardImageView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/21.
//

import UIKit

class CardImageView: UIImageView {
    init(frame: CGRect, cardImage: UIImage) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        image = cardImage
        clipsToBounds = true
        alpha = 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
