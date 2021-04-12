//
//  Users.swift
//  VK
//
//  Created by  Sergei on 25.03.2021.
//
// swiftlint:disable identifier_name nesting

import Foundation
import RealmSwift

// MARK: - Users

extension Json {

    struct Users: Codable {

        let response: Response?

        struct Response: Codable {
            let count: Int
            let items: [Item]
        }

        struct Item: Codable {
            let firstName: String
            let id: Int
            let lastName: String
            let canAccessClosed, isClosed: Bool?
            let sex: Int?
            let screenName: String?
            let photo50, photo100: String?
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
                case online
            }
        }
    }

}

extension Json.Users.Item {

    var description: String {
        "\(lastName) \(firstName)"
    }

    var image: UIImage? {
        NetworkManager.shared.image(url: photo50)
    }

}

// MARK: - UsersJson.Users Comparable

extension Json.Users.Item: Comparable {

    static func == (lhs: Json.Users.Item, rhs: Json.Users.Item) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Json.Users.Item, rhs: Json.Users.Item) -> Bool {
        lhs.description < rhs.description
    }

    static func > (lhs: Json.Users.Item, rhs: Json.Users.Item) -> Bool {
        lhs.description > rhs.description
    }

}

// MARK: - RealmManagerDataProtocol

extension Json.Users: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmUser]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmUser(user: $0)) }
        return realmObjects
    }

}
