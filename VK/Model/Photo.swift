//
//  Photo.swift
//  VK
//
//  Created by  Sergei on 06.01.2021.
//
// swiftlint:disable identifier_name nesting

import UIKit
import RealmSwift

// MARK: - PhotoJson
struct PhotoJSON: Codable {

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
        let sizes: [Size]
        let text: String
        let likes: Likes
        let reposts: Reposts
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

extension PhotoJSON: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmPhoto]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmPhoto(photo: $0)) }
        return realmObjects
    }

//    func toRealm<RealmPhoto>() -> [RealmPhoto] {
//
//        guard let response = self.response else {
//            return [RealmPhoto]()
//        }
//        let realmPhoto = response.items.map { RealmPhoto(photo: $0) }
////        guard let realmPhoto = self.response?.items.map { RealmPhoto(photo: $0) } else { return [RealmPhoto]() }
//        return realmPhoto
//    }
    
}
//// MARK: - PhotoJSON
//struct PhotoJSON: Codable {
//    let response: Response?
//
//    // MARK: - Response
//    struct Response: Codable {
//        let count: Int
//        let items: [Item]
//    }
//
//    // MARK: - Item
//    struct Item: Codable {
//        let albumID, date, id, ownerID: Int
//        let hasTags: Bool
//        let postID: Int
//        let sizes: [Size]
//        let text: String
//        let likes: Likes
//        let reposts, comments: Comments
//        let canComment: Int
//        let tags: Comments
//
//        enum CodingKeys: String, CodingKey {
//            case albumID = "album_id"
//            case date, id
//            case ownerID = "owner_id"
//            case hasTags = "has_tags"
//            case postID = "post_id"
//            case sizes, text, likes, reposts, comments
//            case canComment = "can_comment"
//            case tags
//        }
//    }
//
//    // MARK: - Comments
//    struct Comments: Codable {
//        let count: Int
//    }
//
//    // MARK: - Likes
//    struct Likes: Codable {
//        let userLikes, count: Int
//
//        enum CodingKeys: String, CodingKey {
//            case userLikes = "user_likes"
//            case count
//        }
//    }
//
//    // MARK: - Size
//    struct Size: Codable {
//        let height: Int
//        let url: String
//        let type: String
//        let width: Int
//    }
//
//}

// MARK: - Photos

struct Photos {

    var array: [RealmPhoto] = []
    var count: Int {
        return array.count
    }

    init(realmPhoto: Results<RealmPhoto>?) {
        guard let realmPhoto = realmPhoto else { return }
        for item in realmPhoto where item.sizes.count > 0 {
            self.array.append(item)
        }
    }

}

extension Photos {

    subscript(index: Int) -> RealmPhoto? {
        guard index >= 0, index < self.count else { return nil }
        return array[index]
    }

}
