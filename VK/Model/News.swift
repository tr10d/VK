//
//  News.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import Foundation
import RealmSwift

struct News: Codable {

    let response: Response?

    // MARK: - Response

    struct Response: Codable {
        let count: Int
        let items: [String]
    }

}

extension News: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmNews]()
//        guard let response = self.response else { return realmObjects }
//        response.items.forEach { realmObjects.append(RealmUser(user: $0)) }
        return realmObjects
    }

}
