//
//  Photo.swift
//  VK
//
//  Created by  Sergei on 06.01.2021.
//
// swiftlint:disable identifier_name nesting

import UIKit
import RealmSwift

// MARK: - Photo
struct PhotoJson: Codable {
    let response: Response?

    // MARK: - Response
    struct Response: Codable {
        let count: Int
        let items: [Item]
        let more: Int
    }

    // MARK: - Item
    struct Item: Codable {
        let albumID, date, id, ownerID: Int
        let hasTags: Bool
        let sizes: [Size]?
        let text: String
        let likes: Likes?
        let reposts: Reposts?
        let realOffset: Int

        enum CodingKeys: String, CodingKey {
            case albumID = "album_id"
            case date, id
            case ownerID = "owner_id"
            case hasTags = "has_tags"
            case sizes, text, likes, reposts
            case realOffset = "real_offset"
        }
    }

    // MARK: - Likes
    struct Likes: Codable {
        let userLikes, count: Int

        enum CodingKeys: String, CodingKey {
            case userLikes = "user_likes"
            case count
        }
    }

    // MARK: - Reposts
    struct Reposts: Codable {
        let count: Int
    }

    // MARK: - Size
    struct Size: Codable {
        let height: Int
        let url: String
        let type: String
        let width: Int
    }

}

extension PhotoJson: RealmModifity {

    func saveToRealm() {
        var realmUsers: [RealmPhoto] = []
        response?.items.forEach {
            realmUsers.append(RealmPhoto(photo: $0))
        }
        do {
            let realm = RealmManager.realm
            realm?.beginWrite()
            realm?.add(realmUsers)
            try realm?.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }

}

struct Photo {

    var urlImage: String
    var image: UIImage? {
        guard let data = Data(base64Encoded: urlImage) else { return nil }
        return UIImage(data: data)
    }
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

    init(like: Int, urlImage: String, isLiked: Bool = false) {
        self.like = like
        self.urlImage = urlImage
        self.isLiked = isLiked
    }

    mutating func switchLike() {
        isLiked = !isLiked
    }

}

class Photos {

    var array: [Photo] = []
    var count: Int {
        return array.count
    }

    init(array: [Photo]) {
        self.array = array
    }

    init(realmPhoto: Results<RealmPhoto>?) {
        guard let realmPhoto = realmPhoto else { return }
        for item in realmPhoto where item.sizes.count > 0 {
            let img = item.sizes[0]
            let photo = Photo(like: item.likes?.count ?? 0,
                              urlImage: img.url,
                              isLiked: item.likes?.userLikes == 1)
            self.array.append(photo)
        }
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

// MARK: - will delete

struct ItemImage {
    let name: String
    var image: UIImage? {
        UIImage(named: name)
    }
}
