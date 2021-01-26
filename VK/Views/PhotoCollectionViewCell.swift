//
//  PhotoCollectionViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet weak var photoLike: PhotoLikes!
    @IBOutlet weak var photo: UIImageView!

    override func prepareForReuse() {
        photo.image = nil
    }

}
