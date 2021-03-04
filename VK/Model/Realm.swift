//
//  Realm.swift
//  VK
//
//  Created by  Sergei on 20.02.2021.
//
// swiftlint:disable identifier_name

import UIKit
import RealmSwift

// MARK: - RealmManager

class RealmManager {

    static let realm: Realm? = {
        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "New Realm error")
        #endif
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        return try? Realm(configuration: config)
    }()

    static func getUsers() -> Users {
        Users(realmUser: realm?.objects(RealmUser.self))
    }

    static func getPhotos(realmUser: RealmUser?) -> Photos {
        var realmPhoto: Results<RealmPhoto>?
        if let realmUser = realmUser {
            realmPhoto = realm?.objects(RealmPhoto.self).filter("ownerID == %@", realmUser.id)
        }
        return Photos(realmPhoto: realmPhoto)
    }

    static func getGroups() -> [RealmGroup] {
        var array: [RealmGroup] = []
        realm?.objects(RealmGroup.self).forEach { array.append($0) }
        return array
    }

    static func responseUsers(completionHandler: @escaping () -> Void) {
        NetworkService.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            do {
                let usersJson = try JSONDecoder().decode(UsersJson.self, from: data)
                let realmUsers = usersJson.response.items.map { RealmUser(user: $0) }
                DispatchQueue.main.async {
                    saveData(data: realmUsers)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responsePhotos(realmUser: RealmUser?, completionHandler: @escaping () -> Void) {
        guard let realmUser = realmUser else { return }

        NetworkService.shared.requestPhotos(userId: realmUser.id) { (data, _, _) in
            guard let data = data else { return }
            do {
                let photoJson = try JSONDecoder().decode(PhotoJson.self, from: data)
                let realmPhoto = photoJson.response?.items.map { RealmPhoto(photo: $0) }
                if let realmPhoto = realmPhoto {
                    DispatchQueue.main.async {
                        RealmManager.saveData(data: realmPhoto)
                        completionHandler()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responseGroups(completionHandler: @escaping () -> Void) {
        NetworkService.shared.requestGroups { (data, _, _) in
            guard let data = data else { return }
            do {
                let groups = try JSONDecoder().decode(Groups.self, from: data)
                let realmGroups = groups.response?.items.map { RealmGroup(group: $0) }
                if let realmGroups = realmGroups {
                    DispatchQueue.main.async {
                        RealmManager.saveData(data: realmGroups)
                        completionHandler()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func saveData(data: [Object]) {
        do {
            realm?.beginWrite()
            realm?.add(data, update: .modified)
            try realm?.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }

}

// MARK: - RealmUser

class RealmUser: Object {

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
        self.photo50 = NetworkService.shared.url2str(url: user.photo50)
    }
}

extension RealmUser {

    var screenName: String {
        "\(lastName) \(firstName)"
    }

    var image: UIImage? {
        guard let data = Data(base64Encoded: photo50) else { return nil }
        return UIImage(data: data)
    }

}

extension RealmUser: Comparable {

    static func == (lhs: RealmUser, rhs: RealmUser) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: RealmUser, rhs: RealmUser) -> Bool {
        lhs.screenName < rhs.screenName
    }

    static func > (lhs: RealmUser, rhs: RealmUser) -> Bool {
        lhs.screenName > rhs.screenName
    }

}

// MARK: - RealmGroup

class RealmGroup: Object {

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
        self.photo50 = NetworkService.shared.url2str(url: group.photo50)
        self.photo100 = NetworkService.shared.url2str(url: group.photo100)
        self.photo200 = NetworkService.shared.url2str(url: group.photo200)
    }

}

extension RealmGroup {

    enum SizeImage {
        case small, medium, big
    }

    func getImage(size: SizeImage) -> UIImage? {
        var base64Data = ""

        switch size {
        case .small: base64Data = photo50
        case .medium: base64Data = photo100
        case .big: base64Data = photo200
        }

        guard let data = Data(base64Encoded: base64Data) else { return nil }
        return UIImage(data: data)
    }

}

// MARK: - RealmPhoto

class RealmPhoto: Object {

    @objc dynamic var albumID = 0
    @objc dynamic var date = 0
    @objc dynamic var id = 0
    @objc dynamic var ownerID = 0
    @objc dynamic var hasTags = false
    @objc dynamic var text = ""
    @objc dynamic var realOffset = 0
    @objc dynamic var likes: RealmLikes?
    @objc dynamic var reposts: RealmReposts?

    let sizes = List<RealmSize>()

    override static func primaryKey() -> String? {
      "id"
    }

    convenience init(photo: PhotoJson.Item) {
        self.init()
        self.albumID = photo.albumID
        self.date = photo.date
        self.id = photo.id
        self.ownerID = photo.ownerID
        self.hasTags = photo.hasTags
        self.text = photo.text
        self.realOffset = photo.realOffset

        self.likes = RealmLikes(photo: photo)
        self.reposts = RealmReposts(photo: photo)

        photo.sizes?.forEach { sizes.append(RealmSize(size: $0)) }
   }

}

extension RealmPhoto {

    var image: UIImage? {
        guard sizes.count > 0,
              let data = Data(base64Encoded: sizes[0].url) else { return nil }
        return UIImage(data: data)
    }

    func switchLike() {
        guard let likes = likes, let realm = RealmManager.realm else { return }
        do {
            realm.beginWrite()
            likes.userLikes = likes.userLikes == 0 ? 1 : 0
            try realm.commitWrite()
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

// MARK: - Likes
class RealmLikes: Object {

    @objc dynamic var userLikes = 0
    @objc dynamic var count = 0

    convenience init(photo: PhotoJson.Item) {
        self.init()
        self.userLikes = photo.likes?.userLikes ?? 0
        self.count = photo.likes?.count ?? 0
    }

}

// MARK: - Reposts
class RealmReposts: Object {

    @objc dynamic var count = 0

    convenience init(photo: PhotoJson.Item) {
        self.init()
        self.count = photo.reposts?.count ?? 0
    }

}

// MARK: - Size
class RealmSize: Object {

    @objc dynamic var height = 0
    @objc dynamic var url = ""
    @objc dynamic var type = ""
    @objc dynamic var width = 0

    convenience init(size: PhotoJson.Size) {
        self.init()
        self.height = size.height
        self.url = NetworkService.shared.url2str(url: size.url)
        self.type = size.type
        self.width = size.width
    }

}
