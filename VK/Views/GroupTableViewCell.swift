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

    override func awakeFromNib() {
        super.awakeFromNib()
        awakeFromNibtapGestureRecognizer()
    }

    override func prepareForReuse() {
        groupImage.image = nil
        groupName.text = nil
    }

}

// MARK: - tapGestureRecognizer

extension GroupTableViewCell {

    func awakeFromNibtapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                    action: #selector(imageTapped(tapGestureRecognizer:)))
        self.groupImage.isUserInteractionEnabled = true
        self.groupImage.addGestureRecognizer(tapGestureRecognizer)
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

extension GroupTableViewCell {

    func configure(group: RealmGroup?) {
        guard let group = group else {
            return
        }
        groupImage.image = group.image(size: .small)
        groupName.text = group.name
    }

    func configure(groupItem: Groups.Item?) {
        guard let groupItem = groupItem else { return }
        groupImage.image = groupItem.image
        groupName.text = groupItem.name
    }

}
