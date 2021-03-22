//
//  Loading.swift
//  VK
//
//  Created by  Sergei on 22.01.2021.
//

import UIKit

@IBDesignable
final class Loading: UIControl {

    private var stackView: UIStackView!
    private var circle1, circle2, circle3: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView​()
        animateView​()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView​()
        animateView​()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

}

extension Loading {

    private func setupView​() {

        let color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        circle1 = UIImageView(image: UIImage(systemName: "circle.fill"))
        circle1.tintColor = color
        circle2 = UIImageView(image: UIImage(systemName: "circle.fill"))
        circle2.tintColor = color
        circle3 = UIImageView(image: UIImage(systemName: "circle.fill"))
        circle3.tintColor = color

        stackView = UIStackView(arrangedSubviews: [circle1, circle2, circle3])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        addSubview(stackView)

    }

    func animateView​() {
        let alpha: CGFloat = 0.2
        let duration: Double = 1
        let options: UIView.AnimationOptions = [.repeat, .autoreverse]

        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.circle1.alpha = alpha
        }
        UIView.animate(withDuration: duration, delay: 0.4, options: options) {
            self.circle2.alpha = alpha
        }
        UIView.animate(withDuration: duration, delay: 0.8, options: options) {
            self.circle3.alpha = alpha
        }
    }

}
