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
    var isLiked: Bool
    init(like: Int, image: String, isLiked: Bool = false) {
        self.like = like
        self.image = ItemImage(name: image)
        self.isLiked = isLiked
    }
}
