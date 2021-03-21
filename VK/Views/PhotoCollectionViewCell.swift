//
//  PhotoCollectionViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit
import RealmSwift

class PhotoCollectionViewCell: UICollectionViewCell {

    static let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet weak var photoLike: PhotoLikes!
    @IBOutlet weak var photo: UIImageView!

    override func prepareForReuse() {
        photo.image = nil
    }

//    func configure(photos: Photos?, row: Int) {
//        guard let photos = photos else { return }
//        let searchedPhoto = photos[row]
//        photo.image = searchedPhoto?.image
//        photoLike.setPhoto(photos: photos, row: row)
//    }

    func configure(photos: Results<RealmPhoto>?, row: Int) {
        guard let photos = photos else { return }
        let searchedPhoto = photos[row]
        photo.image = searchedPhoto.image
//        photoLike.setPhoto(photos: photos, row: row)
    }

}
