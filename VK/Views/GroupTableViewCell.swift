//
//  GroupTableViewCell.swift
//  VK
//
//  Created by  Sergei on 31.12.2020.
//

import UIKit

// @IBDesignable
class GroupTableViewCell: UITableViewCell {

//    @IBInspectable
    @IBOutlet weak var groupImage: UIImageView!

//    @IBInspectable
    @IBOutlet weak var groupName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        groupImage.layer.cornerRadius = groupImage.frame.height / 2
//        groupImage.layer.shadowRadius = 20
//        groupImage.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
//        groupImage.layer.shadowOpacity = 5.0
//        groupImage.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
