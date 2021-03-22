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
        NetworkManager.shared.image(url: photo50)
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

// MARK: - RealmManagerDataProtocol

extension UsersJson: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmUser]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmUser(user: $0)) }
        return realmObjects
    }

}
