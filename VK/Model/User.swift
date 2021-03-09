//
//  User.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//
// swiftlint:disable identifier_name nesting

import UIKit
import RealmSwift

// MARK: - UsersJson

struct UsersJson: Codable {

    let response: Response?

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

// MARK: - UsersJson.Users extension

extension UsersJson.User {

    var screenName: String {
        "\(firstName ?? "") \(lastName ?? "")"
    }

    var image: UIImage? {
        NetworkService.shared.image(url: photo50)
    }

}

// MARK: - UsersJson.Users Comparable

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

extension UsersJson: RealmManagerDataProtocol {
    
    func getRealmObject() -> [Object] {
        var realmObjects = [RealmUser]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmUser(user: $0)) }
        return realmObjects
    }

}
//
//// MARK: - Users
//
//struct Users {
//
//    var rawData: [String: [RealmUser]] = [:]
//    var filteredData: [String: [RealmUser]] = [:]
//    var letters: [String]  = []
//    var filter: String = "" {
//        didSet {
//            setFilteredData()
//            setLetters()
//        }
//    }
//    var count: Int {
//        rawData.count
//    }
//
//    init(realmUser: Results<RealmUser>?) {
//        setRawData(realmUser: realmUser)
//        setFilteredData()
//        setLetters()
//    }
//
//}
//
//// MARK: - Users extension
//
//extension Users {
//
//    private mutating func setRawData(realmUser: Results<RealmUser>?) {
//        guard let realmUser = realmUser else {  return }
//        for user in realmUser {
//            let letter = String(user.screenName[user.screenName.startIndex])
//            if rawData[letter] == nil { rawData[letter] = [] }
//            rawData[letter]?.append(user)
//        }
//        for item in rawData {
//            rawData[item.key] = rawData[item.key]?.sorted()
//        }
//    }
//
//    private mutating func setFilteredData() {
//        if filter.isEmpty {
//            filteredData = rawData
//        } else {
//            filteredData = [:]
//            for (key, data) in rawData {
//                let newData = data.filter { $0.screenName.range(of: filter, options: .caseInsensitive) != nil }
//                if !newData.isEmpty {
//                    filteredData[key] = newData.sorted()
//                }
//            }
//        }
//    }
//
//    private mutating func setLetters() {
//        letters = filteredData.map { $0.key }.sorted()
//    }
//
//    func getFriends(key: String) -> [RealmUser] {
//        guard let array = filteredData[key] else {
//            return [RealmUser]()
//        }
//        return array
//    }
//
//    func getFriends(section: Int) -> [RealmUser] {
//        let key = letters[section]
//        return getFriends(key: key)
//    }
//
//    func getFriend(indexPath: IndexPath) -> RealmUser? {
//        let array = getFriends(section: indexPath.section)
//        if array.count <= indexPath.row {
//            return nil
//        }
//        return array[indexPath.row]
//    }
//
//}
