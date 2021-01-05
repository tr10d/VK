//
//  FriendTableViewCell.swift
//  VK
//
//  Created by  Sergei on 04.01.2021.
//

import UIKit

@IBDesignable
class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
