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

class Photos {

    var array: [Photo]
    var count: Int {
        return array.count
    }

    init(array: [Photo]) {
        self.array = array
    }

    func switchLike(index: Int) {
        var element = array.remove(at: index)
        element.switchLike()
        array.insert(element, at: index)
    }

    func getItem(index: Int) -> Photo? {
        if index >= 0 && index < array.count {
            return array[index]
        }
        return nil
    }

}
