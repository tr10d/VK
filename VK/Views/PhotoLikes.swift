//
//  PhotoLikes.swift
//  VK
//
//  Created by  Sergei on 04.01.2021.
//

import UIKit

@IBDesignable
class PhotoLikes: UIControl {

    private var stackView: UIStackView!, button: UIButton!, label: UILabel!
    var photos: Photos?
    var row: Int?

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

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    private func setupView​() {

        let spaceLabel = UILabel()
        let priority = spaceLabel.contentHuggingPriority(for: .horizontal)
        spaceLabel.setContentHuggingPriority(UILayoutPriority(priority.rawValue - 1), for: .horizontal)

        label = UILabel()
        label.text = "0"

        button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(touchLike), for: .touchUpInside)
        button.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)

        stackView = UIStackView(arrangedSubviews: [spaceLabel, label, button])
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 8

        addSubview(stackView)

    }

    @objc
    func touchLike(sender: UIButton) {
        if let row = row, let photos = photos {
            UIView.transition(with: sender, duration: 0.5, options: [.transitionFlipFromLeft]) {
                photos.switchLike(index: row)
            }
            updateView​()
        }
    }

    func updateView​() {
        if let row = row, let currentPhoto = photos?.getItem(index: row) {
            let currentColor = currentPhoto.isLiked ? #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1) : #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.6156862745, alpha: 1)
            label.textColor = currentColor
            label.text = "\(currentPhoto.like)"
            button.tintColor = currentColor
        }
    }

    func setPhoto(photos: Photos, row: Int) {
        self.photos = photos
        self.row = row
        updateView​()
    }

}
