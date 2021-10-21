//
//  CardImageView.swift
//  Roland
//
//  Created by 林希語 on 2021/10/21.
//

import UIKit

class CardImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        image = UIImage(named: "photo")
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
