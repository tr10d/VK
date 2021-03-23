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
        let items: [Item]
    }

    // MARK: - User
    struct Item: Codable {
        let firstName: String
        let id: Int
        let lastName: String
        let canAccessClosed, isClosed: Bool
        let sex: Int?
        let screenName: String?
        let photo50, photo100: String?
//        let onlineInfo: OnlineInfo?
        let online: Int?

        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case id
            case lastName = "last_name"
            case canAccessClosed = "can_access_closed"
            case isClosed = "is_closed"
            case sex
            case screenName = "screen_name"
            case photo50 = "photo_50"
            case photo100 = "photo_100"
//            case onlineInfo = "online_info"
            case online
        }
    }

//    struct User: Codable {
//        let firstName: String?
//        let id: Int?
//        let lastName: String?
//        let photo50: String?
//
//        enum CodingKeys: String, CodingKey {
//            case firstName = "first_name"
//            case id
//            case lastName = "last_name"
//            case photo50 = "photo_50"
//        }
//    }

}

// MARK: - UsersJson.Users extension

extension UsersJson.Item {

    var description: String {
        return "\(firstName) \(lastName)"
    }

    var image: UIImage? {
        NetworkManager.shared.image(url: photo50)
    }

}

// MARK: - UsersJson.Users Comparable

extension UsersJson.Item: Comparable {

    static func == (lhs: UsersJson.Item, rhs: UsersJson.Item) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: UsersJson.Item, rhs: UsersJson.Item) -> Bool {
        lhs.description < rhs.description
    }

    static func > (lhs: UsersJson.Item, rhs: UsersJson.Item) -> Bool {
        lhs.description > rhs.description
    }

}

// MARK: - RealmManagerDataProtocol

extension UsersJson: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmUser]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmUser(user: $0)) }
        return realmObjects
    }

}
