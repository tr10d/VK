//
//  FriendTableViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!

//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(imageTapped(tapGestureRecognizer:)))
        self.friendImage.isUserInteractionEnabled = true
        self.friendImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func prepareForReuse() {
        friendImage.image = nil
        friendName.text = nil
    }

    func set(user: UsersJson.User?) {
        guard let user = user else {
            return
        }
        friendImage.image = user.image
        friendName.text = user.screenName
    }

    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0.7
        springAnimation.toValue = 1
        springAnimation.mass = 0.3
        springAnimation.damping = 1

        tapGestureRecognizer.view?.layer.add(springAnimation, forKey: nil)
    }

}
