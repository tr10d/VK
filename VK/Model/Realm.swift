//
//  Realm.swift
//  VK
//
//  Created by  Sergei on 20.02.2021.
//
// swiftlint:disable identifier_name

import UIKit
import RealmSwift

protocol RealmManagerDataProtocol {
    func getRealmObject() -> [Object]
}

// MARK: - RealmManager

class RealmManager {

    static let shared = RealmManager()

    private let realm: Realm

    private init?() {
        let configurator = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else { return nil }
        self.realm = realm
        #if DEBUG
            print(realm.configuration.fileURL ?? "New Realm error")
        #endif
    }

}

extension RealmManager {

    static func getUsers2(offset: Int = 0, completion: @escaping (Results<RealmUser>) -> Void) {
        guard let realmData = shared?.realm.objects(RealmUser.self).sorted(byKeyPath: "lastName") else { return }
        if realmData.count == offset {
            RealmManager.responseUsers(offset: offset) { completion(realmData) }
        } else {
            completion(realmData)
        }
    }

    static func getPhotos(realmUser: RealmUser?, offset: Int = 0, completion: @escaping (Results<RealmPhoto>) -> Void) {
        guard let realmUser = realmUser else { return }
        guard let realmPhoto = shared?.realm.objects(RealmPhoto.self)
                .filter("ownerID == %@", realmUser.id) else { return }

        if realmPhoto.count == offset {
            RealmManager.responsePhotos(realmUser: realmUser, offset: offset) {
                completion(realmPhoto)
            }
        } else {
            completion(realmPhoto)
        }
    }

    static func getGroups(offset: Int = 0, completion: @escaping (Results<RealmGroup>) -> Void) {
        guard let realmData = shared?.realm.objects(RealmGroup.self) else { return }
        if realmData.count == offset {
            RealmManager.responseGroups(offset: offset) { completion(realmData) }
        } else {
            completion(realmData)
        }
    }

    static func responseUsers(offset: Int = 0, completionHandler: @escaping () -> Void) {
        NetworkService.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            do {
                let usersJson = try JSONDecoder().decode(UsersJson.self, from: data)
                let realmUsers = usersJson.response?.items.map { RealmUser(user: $0) }
                DispatchQueue.main.async {
                    saveData(data: realmUsers!)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responseUsers2(offset: Int = 0, completionHandler: @escaping () -> Void) {
        NetworkService.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            do {
                let realmData = try JSONDecoder().decode(UsersJson.self, from: data).getRealmObject()
                guard !realmData.isEmpty else { return }
                DispatchQueue.main.async {
                    RealmManager.saveData(data: realmData)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responsePhotos(realmUser: RealmUser?, offset: Int = 0, completionHandler: @escaping () -> Void) {
        guard let realmUser = realmUser else { return }

        NetworkService.shared.requestPhotos(userId: realmUser.id, offset: offset) { (data, _, _) in
            guard let data = data else { return }
            do {
                let realmData = try JSONDecoder().decode(PhotoJSON.self, from: data).getRealmObject()
                guard !realmData.isEmpty else { return }
                DispatchQueue.main.async {
                    RealmManager.saveData(data: realmData)
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func responseGroups(offset: Int = 0, completionHandler: @escaping () -> Void) {
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
            try shared?.realm.write {
                shared?.realm.add(data, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension RealmManager {

    func add<T: Object>(object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }

    func add<T: Object>(objects: [T]) throws {
        try realm.write {
            realm.add(objects, update: .all)
        }
    }

    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }

    func update(closure: (() -> Void)) throws {
        try realm.write {
            closure()
        }
    }

    func getObjects<T: Object>() -> Results<T> {
        let result = realm.objects(T.self)
        if result.isEmpty {

        }
        return result
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
        self.photo50 = user.photo50 ?? ""
    }
}

extension RealmUser {

    var screenName: String { "\(lastName) \(firstName)" }
    var image: UIImage? { NetworkService.shared.image(url: photo50) }

}

extension RealmUser: Comparable {

    static func == (lhs: RealmUser, rhs: RealmUser) -> Bool { lhs.id == rhs.id }
    static func < (lhs: RealmUser, rhs: RealmUser) -> Bool { lhs.screenName < rhs.screenName }
    static func > (lhs: RealmUser, rhs: RealmUser) -> Bool { lhs.screenName > rhs.screenName }

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
        case .small: return NetworkService.shared.image(url: photo50)
        case .medium: return NetworkService.shared.image(url: photo100)
        case .big: return NetworkService.shared.image(url: photo200)
        }
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
        return NetworkService.shared.image(url: sizes[0].url)
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

class RealmComments: Object {

    @objc dynamic var count: Int = 0

    convenience init(count: Int) {
        self.init()
        self.count = count
    }

}

class RealmLikes: Object {

    @objc dynamic var userLikes = 0
    @objc dynamic var count = 0

    convenience init(photo: PhotoJSON.Item) {
        self.init()
        self.userLikes = photo.likes.userLikes
        self.count = photo.likes.count
    }

}

class RealmReposts: Object {

    @objc dynamic var count = 0

    convenience init(photo: PhotoJSON.Item) {
        self.init()
        self.count = photo.reposts.count
    }

}

class RealmSize: Object {

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
