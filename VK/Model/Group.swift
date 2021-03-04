//
//  Group.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//
// swiftlint:disable identifier_name nesting

import UIKit

// MARK: - Groups

struct Groups: Codable {

    var response: Response?

    // MARK: - Response
    struct Response: Codable {
        let count: Int
        var items: [Item]
    }

    // MARK: - Item
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

extension Groups {

    var count: Int {
        response?.items.count ?? 0
    }

    subscript(index: Int) -> Groups.Item? {
        response?.items[index]
    }

    mutating func append(_ group: Groups.Item?) {
        guard let group = group else { return }
        response?.items.append(group)
    }

    mutating func remove(at: Int) {
        response?.items.remove(at: at)
    }

}

extension Groups.Item {

    var image: UIImage? {
        NetworkService.shared.image(url: photo50)
    }

}

// MARK: - SearchGroups

struct SearchGroups: Codable {

    let response: Response

    // MARK: - Response
    struct Response: Codable {
        let count: Int
        let items: [Groups.Item]
    }

}

extension SearchGroups {

    var count: Int {
        response.count
    }

    subscript(index: Int) -> Groups.Item? {
        index < response.count ? response.items[index] : nil
    }

}
