//
//  FullPhotoViewController.swift
//  VK
//
//  Created by  Sergei on 26.01.2021.
//

import UIKit
import RealmSwift

class FullPhotoViewController: UIViewController {

    private var photos: Results<RealmPhoto>?
    private var index: Int?
    private var animator = Animator()

    @IBOutlet weak var photoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadAnimator()

        if let index = index {
            photoImage.image = photos?[index].image
        }

    }

    func configure(photos: Results<RealmPhoto>?, index: Int) {
        self.photos = photos
        self.index = index
    }

}

extension FullPhotoViewController {

    func viewDidLoadAnimator() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        photoImage.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        photoImage.addGestureRecognizer(tap)

        photoImage.isUserInteractionEnabled = true
    }

    @objc func onPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            animator.began(view: photoImage)
        case .changed:
            animator.changed(recognizer: sender, view: photoImage)
        case .ended:
            let currentIndex = index ?? 0
            let direction = animator.ended(view: photoImage,
                                           backPhoto: photos?[currentIndex - 1],
                                           forwardPhoto: photos?[currentIndex + 1])
            if let direction = direction {
                switch direction {
                case .back:
                    index! -= 1
                case .forward:
                    index! += 1
                }
            }

        default:
            break
        }
    }

    @objc func onTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true)
        }
    }

}
