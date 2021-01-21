//
//  PhotoLikes.swift
//  VK
//
//  Created by  Sergei on 04.01.2021.
//

import UIKit

@IBDesignable
class PhotoLikes: UIControl {

    private var likesCount = 0
    private var isLiked = false
    private var stackView: UIStackView!, button: UIButton!, label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView​()
        updateView​()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView​()
        updateView​()
    }

    private func setupView​() {

        button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(touchLike), for: .touchUpInside)
        button.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)

        label = UILabel()

        stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.spacing = 10

        addSubview(stackView)

    }

    @objc
    func touchLike(sender: UIButton) {
        isLiked = !isLiked
        if isLiked {
            likesCount += 1
        } else {
            likesCount -= 1
        }
        updateView​()
    }

    func updateView​() {
        let currentColor = isLiked ? #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1) : #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.6156862745, alpha: 1)
        label.textColor = currentColor
        label.text = "\(likesCount)"
        button.tintColor = currentColor
   }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

}
