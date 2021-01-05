//
//  FriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {

    var photos = [UIImage?]()
    var friend: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let friend = friend {
            photos = NetworkService().getPhotos(user: friend)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        return cell
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
//                                                            for: indexPath) as? FriendsPhotoCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        cell.friendPhoto.image = photos[indexPath.row]
//        cell.contentMode = .scaleAspectFit
//        return cell
    }

}
