//
//  FriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//

import UIKit
import RealmSwift

class FriendsPhotoCollectionViewController: UICollectionViewController {

    private var user: RealmUser?
    private var photos: Results<RealmPhoto>?
    private var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
        viewDidLoadRequest()
        viewDidLoadNotificationToken()
    }

    deinit {
        deinitNotificationToken()
    }

    func configure(user: RealmUser?) {
        self.user = user
    }

}

// MARK: - Request

extension FriendsPhotoCollectionViewController {

    func viewDidLoadRequest() {
        loadPhotos {
            self.collectionView.reloadData()
        }
    }

    func loadPhotos(offset: Int = 0, completion: @escaping () -> Void) {
        RealmManager.getPhotos(realmUser: user, offset: offset) { photos in
            self.photos = photos
            completion()
        }
    }

}

// MARK: - UICollectionViewDataSource

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
        loadPhotos { self.collectionView.refreshControl?.endRefreshing() }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let photos = photos else {
            return
        }
        let lastCount = photos.count
        if indexPath.row == lastCount - 1 {
            loadPhotos(offset: lastCount) {}
        }
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

// MARK: - UICollectionViewDelegate

extension FriendsPhotoCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let fullPhotoVC = Animator.getViewController("FullPhotoViewController") as? FullPhotoViewController
        else { return }
        fullPhotoVC.configure(photos: photos, index: indexPath.row)
        fullPhotoVC.transitioningDelegate = self
        present(fullPhotoVC, animated: true)
    }

}

// MARK: - UIViewControllerTransitioningDelegate

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

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - NotificationToken

extension FriendsPhotoCollectionViewController {

    func viewDidLoadNotificationToken() {
        notificationToken = photos?.observe { [weak self] change in
            switch change {
            case .initial(let users):
                print("Initialize \(users.count)")
            case .update( _,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                self?.collectionView.deleteItems(at: deletions.indexPaths)
                self?.collectionView.insertItems(at: insertions.indexPaths)
                self?.collectionView.reloadItems(at: modifications.indexPaths)
            case .error(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func deinitNotificationToken() {
        notificationToken?.invalidate()
    }

    private func convertNotificationToken(_ array: [Int]) -> [IndexPath] {
        array.map { IndexPath(item: $0, section: 0) }
    }

    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: completion)
    }

}
