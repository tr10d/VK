//
//  FriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {

    var photos: Photos?
    var user: RealmUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
        viewDidLoadRequest()
    }

}

// MARK: - Request

extension FriendsPhotoCollectionViewController {

    func viewDidLoadRequest() {
        loadPhotos()
        if photos == nil || photos?.count == 0 { getDataFromVK() }
    }

    func loadPhotos() {
        photos = RealmManager.getPhotos(realmUser: user)
        collectionView.reloadData()
    }

    func getDataFromVK() {
        RealmManager.responsePhotos(realmUser: user) {
            self.loadPhotos()
            self.collectionView.refreshControl?.endRefreshing()
       }
    }
}

// MARK: UICollectionViewDataSource

extension FriendsPhotoCollectionViewController {

    func viewDidLoadDataSource() {
        collectionView.register(PhotoCollectionViewCell.nib,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh from VK")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl

    }

    @objc func refresh(_ sender: AnyObject) {
        getDataFromVK()
    }

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
        guard let fullPhotoVC = Animator.getViewController("FullPhotoViewController") as? FullPhotoViewController
        else { return }
        fullPhotoVC.configure(photos: photos, index: indexPath.row)
        fullPhotoVC.transitioningDelegate = self
        present(fullPhotoVC, animated: true)
    }

}

// MARK: UIViewControllerTransitioningDelegate

extension FriendsPhotoCollectionViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Animator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Animator(isPresenting: false)
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
