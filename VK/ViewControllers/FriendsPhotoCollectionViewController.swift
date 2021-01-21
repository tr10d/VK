//
//  FriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var photos: Photos?
    var friend: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let friend = friend {
            photos = NetworkService().getPhotos(user: friend)
            print("get photos by \(friend)")
        }
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "Cell")

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.array.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.bounds.size)
        let size = Int(min(collectionView.bounds.width, collectionView.bounds.height) / 3)
        return CGSize(width: size, height: size)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
                as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let photos = photos {
            let photo = photos.getItem(index: indexPath.row)
            cell.photo.image = photo.image.image
            cell.photoLike.setPhoto(photos: photos, row: indexPath.row)
        }
//        cell.contentView.bounds.size.width = 70
//        cell.contentView.bounds.size.height = 120

        return cell
    }

}

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoLike: PhotoLikes!
    @IBOutlet weak var photo: UIImageView!
}
