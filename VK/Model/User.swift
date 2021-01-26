//
//  User.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//
// swiftlint:disable identifier_name

import UIKit

struct Users {
    private var rawData: [String: [User]] = [:]
    private var filteredData: [String: [User]] = [:]
    var letters: [String]  = []
    var filter: String = "" {
        didSet {
            setFilteredData()
            setLetters()
        }
    }

    // MARK: - Private

    private mutating func setFilteredData() {
        if filter.isEmpty {
            filteredData = rawData
        } else {
            filteredData = [:]
            for (key, data) in rawData {
                let newData = data.filter { $0.name.range(of: filter, options: .caseInsensitive) != nil }
                if !newData.isEmpty {
                    filteredData[key] = newData.sorted()
                }
            }
        }
    }

    private mutating func setLetters() {
        letters = filteredData.map { $0.key }.sorted()
    }

    // MARK: - Public

    func getFriends(key: String) -> [User] {
        guard let array = filteredData[key] else {
            return [User]()
        }
        return array
    }

    func getFriends(section: Int) -> [User] {
        let key = letters[section]
        return getFriends(key: key)
    }

    func getFriend(indexPath: IndexPath) -> User? {
        let array = getFriends(section: indexPath.section)
        if array.count <= indexPath.row {
            return nil
        }
        return array[indexPath.row]
    }

    mutating func append(id: Int, name: String, image: String) {
        let user = User(id: id, name: name, image: image)
        let letter = String(name[name.startIndex])
        if rawData[letter] == nil {
            rawData[letter] = [User]()
        }
        rawData[letter]?.append(user)
        setFilteredData()
        setLetters()
    }

}

struct User {
    let id: Int
    let name: String
    var image: ItemImage

    init() {
        self.id = Randoms.randomInt()
        self.name = "\(Randoms.randomFakeName())"
        self.image = ItemImage(name: "User-\(Int.random(1, 12))")
    }

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
