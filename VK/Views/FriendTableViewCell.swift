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

    override func prepareForReuse() {
        friendImage.image = nil
        friendName.text = nil
    }

    func set(friend: User?) {
        guard let friend = friend else {
            return
        }
        friendImage.image = friend.image.image
        friendName.text = friend.name
    }
}
