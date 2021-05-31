//
//  CircularImageView.swift
//  VK
//
//  Created by  Sergei on 03.01.2021.
//

import UIKit

@IBDesignable
final class CircularImageView: UIImageView {

    @IBInspectable
    var shadowRadius: CGFloat = 2.0 {
        didSet {
            superview?.layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            superview?.layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable
    var shadowOpacity: Float = 0.7 {
        didSet {
            superview?.layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable
    var shadowColor: UIColor = .black {
        didSet {
            superview?.layer.shadowColor = shadowColor.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
      layer.borderColor = Constants.colors.black.cgColor
        layer.borderWidth = 0.1
        layer.masksToBounds = true

        superview?.backgroundColor = Constants.colors.clear
        superview?.layer.shadowRadius = 2
        superview?.layer.shadowOffset = CGSize(width: 3, height: 3)
        superview?.layer.shadowOpacity = 0.7
        superview?.layer.shadowColor = Constants.colors.black.cgColor
    }

}
