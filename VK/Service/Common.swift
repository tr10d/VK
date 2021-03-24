//
//  Common.swift
//  VK
//
//  Created by  Sergei on 09.03.2021.
//

import UIKit

struct API {
    static let version = "5.130"

    enum Scopes: Int {
        case friends = 2
        case photos = 4
        case wall = 8192
        case groups = 262144
    }

    enum FilterItems: String {
        case post = "post"
        case photo = "photo"
    }

    struct Filters {
        let newsFeed = FiltersNewsFeed()

        struct FiltersNewsFeed {
            let post = FilterItems.post.rawValue
            let photo = FilterItems.photo.rawValue
        }
    }

}

extension Array where Element == Int {

    var indexPaths: [IndexPath] {
        self.map { IndexPath(item: $0, section: 0) }
    }

}

extension Array where Element == API.Scopes {

    var scope: String {
        self.reduce(0) { result, element in
            result + element.rawValue
        }.description
    }
}

extension Array where Element == API.FilterItems {

    var filters: String {
        self.map {
            $0.rawValue
        }.joined(separator: ",")
    }
}

extension UIImageView {
    
    func setLikes(_ isLikes: Bool) {
        if isLikes {
            self.image = UIImage(systemName: "suit.heart.fill")
        } else {
            self.image = UIImage(systemName: "suit.heart")
        }
    }

}
