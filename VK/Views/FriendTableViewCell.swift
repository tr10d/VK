//
//  FriendTableViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

final class FriendTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet private weak var friendImage: UIImageView!
    @IBOutlet private weak var friendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        awakeFromNibGestureRecognizer()

    }

    override func prepareForReuse() {
        friendImage.image = nil
        friendName.text = nil
    }

}

extension FriendTableViewCell {

    func awakeFromNibGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(imageTapped(tapGestureRecognizer:)))
        self.friendImage.isUserInteractionEnabled = true
        self.friendImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0.7
        springAnimation.toValue = 1
        springAnimation.mass = 0.3
        springAnimation.damping = 1

        tapGestureRecognizer.view?.layer.add(springAnimation, forKey: nil)
    }

}

extension FriendTableViewCell {

    func set(user: Json.Users.Item?) {
        guard let user = user else {
            return
        }
        friendImage.image = user.image
        friendName.text = user.screenName
    }

    func set(realmUser: RealmUser?) {
        guard let realmUser = realmUser else {
            return
        }
        friendImage.image = realmUser.image
        friendName.text = realmUser.screenName
    }

}
