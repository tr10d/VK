//
//  Realm.swift
//  VK
//
//  Created by  Sergei on 20.02.2021.
//
// swiftlint:disable identifier_name

import UIKit
import RealmSwift

protocol RealmModifity {

    func saveToRealm()

}

class RealmManager {

    enum DataType {
        case users
        case photo
    }

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

    static func responseUsers(dataType: DataType, completionHandler: @escaping () -> Void) {
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
        guard let realmUser = realmUser else {
            return
        }

        NetworkService.shared.requestPhotos(userId: realmUser.id) { (data, _, _) in
            guard let data = data else { return }
            do {
                let photoJson = try JSONDecoder().decode(PhotoJson.self, from: data)
                let realmPhoto = photoJson.response?.items.map { RealmPhoto(photo: $0) }
                if let realmPhoto = realmPhoto {
                    DispatchQueue.main.async {
                        RealmManager.saveData(data: realmPhoto)
                        completionHandler()
    //                    self.collectionView.reloadData()
                    }
                }
                //                photoJson.saveToRealm()
//                self.photos = Photos(photoJson: photoJson)

            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func saveData(data: [Object]) {
//        DispatchQueue.main.async {
            do {
                realm?.beginWrite()
                realm?.add(data, update: .modified)
                try realm?.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
//        }
    }

}

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
