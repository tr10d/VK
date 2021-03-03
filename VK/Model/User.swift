//
//  User.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//
// swiftlint:disable identifier_name nesting

import UIKit
import RealmSwift

// MARK: - Users

struct UsersJson: Codable {

    let response: Response

    // MARK: - Response

    struct Response: Codable {
        let count: Int
        let items: [User]
    }

    // MARK: - User

    struct User: Codable {
        let firstName: String?
        let id: Int?
        let lastName: String?
        let photo50: String?

        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case id
            case lastName = "last_name"
            case photo50 = "photo_50"
        }
    }

}

//extension UsersJson {
//
//    init(realmUser: [RealmUser]) {
//        
//        var items: [UsersJson.User] = []
//        realmUser.forEach {
//            let user = UsersJson.User(firstName: $0.firstName,
//                                      id: $0.id,
//                                      lastName: $0.lastName,
//                                      photo50: $0.photo50)
//            items.append(user)
//        }
//        response = Response(count: realmUser.count, items: items)
//        
//    }
//    
//}

//extension UsersJson: RealmModifity {
//
//    func saveToRealm() {
//        var realmUsers: [RealmUser] = []
//        response.items.forEach {
//            realmUsers.append(RealmUser(user: $0))
//        }
//        do {
//            let realm = RealmManager.realm
//            realm?.beginWrite()
//            realm?.add(realmUsers)
//            try realm?.commitWrite()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//}

extension UsersJson.User {

    var screenName: String {
        "\(firstName ?? "") \(lastName ?? "")"
    }

    var image: UIImage? {
        NetworkService.shared.image(url: photo50)
    }

}

extension UsersJson.User: Comparable {

    static func == (lhs: UsersJson.User, rhs: UsersJson.User) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: UsersJson.User, rhs: UsersJson.User) -> Bool {
        lhs.screenName < rhs.screenName
    }

    static func > (lhs: UsersJson.User, rhs: UsersJson.User) -> Bool {
        lhs.screenName > rhs.screenName
    }

}

struct Users {

    var rawData: [String: [RealmUser]] = [:]
    var filteredData: [String: [RealmUser]] = [:]
    var letters: [String]  = []
    var filter: String = "" {
        didSet {
            setFilteredData()
            setLetters()
        }
    }

//    init(usersJson: UsersJson) {
//        setRawData(usersJson: usersJson)
//        setFilteredData()
//        setLetters()
//    }

    init(realmUser: Results<RealmUser>?) {
        setRawData(realmUser: realmUser)
        setFilteredData()
        setLetters()
    }
//    init(realmUser: Results<RealmUser>?) {
//        guard let realmUser = realmUser else {  return }
//        for user in realmUser {
//            let letter = String(user.lastName[user.lastName.startIndex])
//            if rawData[letter] == nil { rawData[letter] = [] }
//            rawData[letter]?.append(user)
//        }
//    }

    private mutating func setRawData(realmUser: Results<RealmUser>?) {
        guard let realmUser = realmUser else {  return }
       for user in realmUser {
            let letter = String(user.screenName[user.screenName.startIndex])
            if rawData[letter] == nil { rawData[letter] = [] }
            rawData[letter]?.append(user)
        }
        for item in rawData {
            rawData[item.key] = rawData[item.key]?.sorted()
        }
    }
//    private mutating func setRawData(usersJson: UsersJson) {
//        for user in usersJson.response.items {
//            let letter = String(user.screenName[user.screenName.startIndex])
//            if rawData[letter] == nil { rawData[letter] = [] }
//            rawData[letter]?.append(user)
//        }
//        for item in rawData {
//            rawData[item.key] = rawData[item.key]?.sorted()
//        }
//    }

    private mutating func setFilteredData() {
        if filter.isEmpty {
            filteredData = rawData
        } else {
            filteredData = [:]
            for (key, data) in rawData {
                let newData = data.filter { $0.screenName.range(of: filter, options: .caseInsensitive) != nil }
                if !newData.isEmpty {
                    filteredData[key] = newData.sorted()
                }
            }
        }
    }

    private mutating func setLetters() {
        letters = filteredData.map { $0.key }.sorted()
    }

    func getFriends(key: String) -> [RealmUser] {
        guard let array = filteredData[key] else {
            return [RealmUser]()
        }
        return array
    }

    func getFriends(section: Int) -> [RealmUser] {
        let key = letters[section]
        return getFriends(key: key)
    }

    func getFriend(indexPath: IndexPath) -> RealmUser? {
        let array = getFriends(section: indexPath.section)
        if array.count <= indexPath.row {
            return nil
        }
        return array[indexPath.row]
    }

}
