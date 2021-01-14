//
//  FriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {

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
        return cell
    }

}

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoLike: PhotoLikes!
    @IBOutlet weak var photo: UIImageView!

}
