//
//  Photo.swift
//  VK
//
//  Created by  Sergei on 06.01.2021.
//

import UIKit

struct ItemImage {
    let name: String
    var image: UIImage? {
        UIImage(named: name)
    }
}

struct Photo {
    var image: ItemImage
    var like: Int
    var isLiked: Bool {
        didSet {
            let count: Int
            switch isLiked {
            case true:
                count = 1
            case false:
                count = -1
            }
            like += count
        }
    }

    init() {
        like = Int.random(0, 123)
        image = ItemImage(name: "Photo-\(Int.random(1, 30))")
        isLiked = like == 0 ? false : Bool.random()
    }

    init(like: Int, image: String, isLiked: Bool = false) {
        self.like = like
        self.image = ItemImage(name: image)
        self.isLiked = isLiked
    }

    mutating func switchLike() {
        isLiked = !isLiked
    }
}
