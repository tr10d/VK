//
//  FriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {

    var photos = [Photo]()
    var friend: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let friend = friend {
            photos = NetworkService().getPhotos(user: friend)
        }
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "Cell")
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
                as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.row]
        cell.photo.image = photo.image.image
        return cell
    }

}

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!

}
