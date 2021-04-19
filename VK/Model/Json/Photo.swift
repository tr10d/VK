//
//  Photo.swift
//  VK
//
//  Created by  Sergei on 25.03.2021.
//
// swiftlint:disable identifier_name nesting

import Foundation
import RealmSwift

extension Json {

    struct Photo: Codable {

        let response: Response?

        // MARK: - Response
        struct Response: Codable {
            let count: Int
            let items: [Item]
            let more: Int?
        }

        // MARK: - Item
        struct Item: Codable {
            let albumID, date, id, ownerID: Int
            let hasTags: Bool
            let sizes: [Size]
            let text: String
            let likes: Likes?
            let reposts: Reposts?
            let realOffset: Int?

            enum CodingKeys: String, CodingKey {
                case albumID = "album_id"
                case date, id
                case ownerID = "owner_id"
                case hasTags = "has_tags"
                case sizes, text, likes, reposts
                case realOffset = "real_offset"
            }
        }
    }

}

extension Json.Photo: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmPhoto]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmPhoto(photo: $0)) }
        return realmObjects
    }

}

extension Json.Photo.Item {
  func urlForWidthScreen() -> String {
    var element = sizes.last
    let widthScreen = Int(UIScreen.main.bounds.width)
    let weightSizes = sizes.map { abs($0.width - widthScreen) }

    if let variance = weightSizes.min(),
      let indexMinimumElement = weightSizes.firstIndex(of: variance) {
      element = sizes[indexMinimumElement]
    }
    return element?.url ?? ""
  }

  func elementForWidthScreen() -> Json.Size? {
    var element = sizes.last
    let widthScreen = Int(UIScreen.main.bounds.width)
    let weightSizes = sizes.map { abs($0.width - widthScreen) }

    if let variance = weightSizes.min(),
      let indexMinimumElement = weightSizes.firstIndex(of: variance) {
      element = sizes[indexMinimumElement]
    }
    return element
  }
}
