//
//  FullPhotoViewController.swift
//  VK
//
//  Created by  Sergei on 26.01.2021.
//

import UIKit

class FullPhotoViewController: UIViewController {

    private var photos: Photos?
    private var index: Int?
    private var animator = Animator()

    @IBOutlet weak var photoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = index {
            photoImage.image = photos?.getItem(index: index)?.image.image
        }

        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        photoImage.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        photoImage.addGestureRecognizer(tap)

        photoImage.isUserInteractionEnabled = true
    }

    func configure(photos: Photos?, index: Int) {
        self.photos = photos
        self.index = index
    }

    @objc
    func onPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            animator.began(view: photoImage)
        case .changed:
            animator.changed(recognizer: sender, view: photoImage)
        case .ended:
            let currentIndex = index ?? 0
            let direction = animator.ended(view: photoImage,
                                           backPhoto: photos?.getItem(index: currentIndex - 1),
                                           forwardPhoto: photos?.getItem(index: currentIndex + 1))
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

    @objc
    func onTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true)
        }
    }

}
