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
        photos = NetworkService().getPhotos(friend)
        collectionView.register(PhotoCollectionViewCell.nib,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)

    }

}

// MARK: UICollectionViewDataSource

extension FriendsPhotoCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.identifier,
                for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(photos: photos, row: indexPath.row)
        return cell
    }

}

// MARK: UICollectionViewDelegate

extension FriendsPhotoCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let fullPhotoVC = storyboard?.instantiateViewController(
                identifier: "FullPhotoViewController") as? FullPhotoViewController else { return }

        fullPhotoVC.configure(photos: photos, index: indexPath.row)

        present(fullPhotoVC, animated: true)
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension FriendsPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Int(min(collectionView.bounds.width, collectionView.bounds.height) / 3)
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

}
