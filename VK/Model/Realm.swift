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
    }

    static let realm: Realm? = {
        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "New Realm error")
        #endif
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        return try? Realm(configuration: config)
    }()

    static func getUsers() -> Users? {
        Users(realmUser: realm?.objects(RealmUser.self))
    }

    static func getFromVK(dataType: DataType, completionHandler: @escaping () -> Void) {
//        var realmUsers: [RealmUser] = []
//        userJson.response.items.forEach { realmUsers.append(RealmUser(user: $0)) }
//        saveData(data: realmUsers)
        
        NetworkService.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            do {
                let usersJson = try JSONDecoder().decode(UsersJson.self, from: data)
                let realmUsers = usersJson.response.items.map { RealmUser(user: $0) }
//                var realmUsers: [RealmUser] = []
//                userJson.response.items.forEach { realmUsers.append(RealmUser(user: $0)) }
                DispatchQueue.main.async {
                    saveData(data: realmUsers)
                    completionHandler()
//                   RealmManager.setUsers(userJson: usersJson)
//                    self.loadUsers()
                }
            } catch {
                print(error.localizedDescription)
            }
//            self.tableView.refreshControl?.endRefreshing()
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
//    @objc dynamic var likesUserLikes = 0
//    @objc dynamic var likesCount = 0
//    @objc dynamic var repostsCount = 0
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

//        self.likesUserLikes = photo.likes?.userLikes ?? 0
//        self.likesCount = photo.likes?.count ?? 0
//        self.repostsCount = photo.reposts?.count ?? 0

        photo.sizes?.forEach {
            sizes.append(RealmSize(size: $0))
        }

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
        self.url = size.url
        self.type = size.type
        self.width = size.width
    }

}
