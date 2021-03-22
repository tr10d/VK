//
//  Realm.swift
//  VK
//
//  Created by  Sergei on 20.02.2021.
//
// swiftlint:disable identifier_name

import UIKit
import RealmSwift

// MARK: - RealmUser

final class RealmUser: Object {

    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo50 = ""

    override static func primaryKey() -> String? {
      "id"
    }

    convenience init(user: UsersJson.User) {
        self.init()
        self.id = user.id ?? 0
        self.firstName = user.firstName ?? ""
        self.lastName = user.lastName ?? ""
        self.photo50 = user.photo50 ?? ""
    }
}

extension RealmUser {

    var screenName: String { "\(lastName) \(firstName)" }
    var image: UIImage? { NetworkManager.shared.image(url: photo50) }

}

extension RealmUser: Comparable {

    static func == (lhs: RealmUser, rhs: RealmUser) -> Bool { lhs.id == rhs.id }
    static func < (lhs: RealmUser, rhs: RealmUser) -> Bool { lhs.screenName < rhs.screenName }
    static func > (lhs: RealmUser, rhs: RealmUser) -> Bool { lhs.screenName > rhs.screenName }

}

// MARK: - RealmGroup

final class RealmGroup: Object {

    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var screenName = ""
    @objc dynamic var isClosed = false
    @objc dynamic var type = ""
    @objc dynamic var isAdmin = false
    @objc dynamic var isMember = false
    @objc dynamic var isAdvertiser = false
    @objc dynamic var photo50 = ""
    @objc dynamic var photo100 = ""
    @objc dynamic var photo200 = ""

    override static func primaryKey() -> String? {
      "id"
    }

    convenience init(group: Groups.Item) {
        self.init()
        self.id = group.id
        self.name = group.name
        self.screenName = group.screenName
        self.isClosed = (group.isClosed != 0)
        self.type = group.type
        self.isAdmin = (group.isAdmin != 0)
        self.isMember = (group.isMember != 0)
        self.isAdvertiser = (group.isAdvertiser != 0)
        self.photo50 = group.photo50
        self.photo100 = group.photo100
        self.photo200 = group.photo200
   }

}

extension RealmGroup {

    enum SizeImage {
        case small, medium, big
    }

    func image(size: SizeImage = .small) -> UIImage? {
        switch size {
        case .small: return NetworkManager.shared.image(url: photo50)
        case .medium: return NetworkManager.shared.image(url: photo100)
        case .big: return NetworkManager.shared.image(url: photo200)
        }
    }

}

// MARK: - RealmPhoto

final class RealmPhoto: Object {

    @objc dynamic var albumID = 0
    @objc dynamic var date = 0
    @objc dynamic var id = 0
    @objc dynamic var ownerID = 0
    @objc dynamic var hasTags = false
    @objc dynamic var text = ""
    @objc dynamic var realOffset = 0
    @objc dynamic var likes: RealmLikes?
    @objc dynamic var reposts: RealmReposts?

    // https://vk.com/dev/photo_sizes
    var sizes = List<RealmSize>()

    override static func primaryKey() -> String? {
        "id"
    }

    convenience init(photo: PhotoJSON.Item) {
        self.init()
        self.albumID = photo.albumID
        self.date = photo.date
        self.id = photo.id
        self.ownerID = photo.ownerID
        self.hasTags = photo.hasTags
        self.text = photo.text
        self.likes = RealmLikes(photo: photo)
        self.reposts = RealmReposts(photo: photo)

        photo.sizes.forEach { sizes.append(RealmSize(size: $0)) }
   }

}

extension RealmPhoto {

    var image: UIImage? {
        guard sizes.count > 0 else { return nil }
        return NetworkManager.shared.image(url: sizes[0].url)
    }

    func switchLike() {
        do {
            try RealmManager.shared?.update {
                if let likes = self.likes {
                    likes.userLikes = likes.userLikes == 0 ? 1 : 0
                }
            }
        } catch {
            print(error)
        }
    }

    var isLiked: Bool {
        likes?.userLikes == 1 ? true : false
    }

    var likesCount: Int {
        likes?.count ?? 0
    }

}

final class RealmComments: Object {

    @objc dynamic var count: Int = 0

    convenience init(count: Int) {
        self.init()
        self.count = count
    }

}

final class RealmLikes: Object {

    @objc dynamic var userLikes = 0
    @objc dynamic var count = 0

    convenience init(photo: PhotoJSON.Item) {
        self.init()
        self.userLikes = photo.likes.userLikes
        self.count = photo.likes.count
    }

}

final class RealmReposts: Object {

    @objc dynamic var count = 0

    convenience init(photo: PhotoJSON.Item) {
        self.init()
        self.count = photo.reposts.count
    }

}

final class RealmSize: Object {

    @objc dynamic var height = 0
    @objc dynamic var url = ""
    @objc dynamic var type = ""
    @objc dynamic var width = 0

    convenience init(size: PhotoJSON.Size) {
        self.init()
        self.height = size.height
        self.url = size.url
        self.type = size.type
        self.width = size.width
    }

}

// MARK: - RealmNews

final class RealmNews: Object {

    @objc dynamic var id = 0

    override static func primaryKey() -> String? {
        "id"
    }

}
