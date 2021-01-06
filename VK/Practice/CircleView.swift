//
//  CircleView.swift
//  VK
//
//  Created by  Sergei on 05.01.2021.
//

import UIKit

@IBDesignable
class CircleView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
//        backgroundColor = UIColor.green
//        layer.masksToBounds = true

        layer.cornerRadius = bounds.width / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.7
    }

}
