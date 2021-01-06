//
//  User.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//
// swiftlint:disable identifier_name

import Foundation

struct Users {
    var data: [String: [User]] = [:]
    var letters: [String] {
        return data.map { $0.key }.sorted()
    }

    mutating func append(id: Int, name: String, image: String) {
        let user = User(id: id, name: name, image: image)
        let letter = String(name[name.startIndex])
        if data[letter] == nil {
            data[letter] = [User]()
        }
        data[letter]?.append(user)
        data[letter]?.sort()
    }
}

struct User {
    let id: Int
    let name: String
    var image: ItemImage
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = ItemImage(name: image)
    }
}

extension User: Comparable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: User, rhs: User) -> Bool {
        lhs.name < rhs.name
    }
}
