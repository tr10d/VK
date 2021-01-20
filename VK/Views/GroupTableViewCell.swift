//
//  GroupTableViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!

    override func prepareForReuse() {
        groupImage.image = nil
        groupName.text = nil
    }

    func set(group: Group?) {
        guard let group = group else { return }
        groupImage.image = group.image.image
        groupName.text = group.name
    }

}
