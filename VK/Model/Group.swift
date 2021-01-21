//
//  Group.swift
//  VK
//
//  Created by  Sergei on 29.12.2020.
//
// swiftlint:disable identifier_name

import Foundation

struct Group {
    let id: Int
    let name: String
    var image: ItemImage
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = ItemImage(name: image)
    }
}

extension Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
}
