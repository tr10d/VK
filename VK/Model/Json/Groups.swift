//
//  Groups.swift
//  VK
//
//  Created by  Sergei on 25.03.2021.
//
// swiftlint:disable identifier_name nesting

import Foundation
import RealmSwift

// MARK: - Groups

extension Json {

    struct Groups: Codable {

        var response: Response?

        struct Response: Codable {
            let count: Int
            var items: [Item]
        }

        struct Item: Codable {
            let id: Int
            let name, screenName: String
            let isClosed: Int
            let type: String
            let isAdmin, isMember, isAdvertiser: Int
            let photo50, photo100, photo200: String

            enum CodingKeys: String, CodingKey {
                case id, name
                case screenName = "screen_name"
                case isClosed = "is_closed"
                case type
                case isAdmin = "is_admin"
                case isMember = "is_member"
                case isAdvertiser = "is_advertiser"
                case photo50 = "photo_50"
                case photo100 = "photo_100"
                case photo200 = "photo_200"
            }
        }

    }

}

extension Json.Groups {

    var count: Int {
        response?.items.count ?? 0
    }

    subscript(index: Int) -> Json.Groups.Item? {
        response?.items[index]
    }

    mutating func append(_ group: Json.Groups.Item?) {
        guard let group = group else { return }
        response?.items.append(group)
    }

    mutating func remove(at: Int) {
        response?.items.remove(at: at)
    }

}

extension Json.Groups.Item {

    var image: UIImage? {
        NetworkManager.shared.image(url: photo50)
    }

}

// MARK: - SearchGroups

extension Json {

    struct SearchGroups: Codable {
        let response: Response

        struct Response: Codable {
            let count: Int
            let items: [Json.Groups.Item]
        }
    }

}

extension Json.SearchGroups {

    var count: Int {
        response.count
    }

    subscript(index: Int) -> Json.Groups.Item? {
        index < response.count ? response.items[index] : nil
    }

}
