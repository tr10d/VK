//
//  Misc.swift
//  VK
//
//  Created by  Sergei on 25.03.2021.
//
// swiftlint:disable identifier_name nesting

import UIKit

// MARK: - Misc

extension Json {

    // MARK: - Info
    struct Info: Codable {

        let response: Response

        // MARK: - Response
        struct Response: Codable {
            let country: String
        }

    }

    // MARK: - Attachment
    struct Attachment: Codable {
        let type: String
        let photo: Photo.Item?
//        let doc: Doc?
//        let link: Link?
      enum CodingKeys: String, CodingKey {
          case type, photo
      }
    }

    // MARK: - Comments
    struct Comments: Codable {
        let count, canPost: Int?
        let groupsCanPost: Bool?

        enum CodingKeys: String, CodingKey {
            case count
            case canPost = "can_post"
            case groupsCanPost = "groups_can_post"
        }
    }

    // MARK: - Donut
    struct Donut: Codable {
        let isDonut: Bool

        enum CodingKeys: String, CodingKey {
            case isDonut = "is_donut"
        }
    }

    // MARK: - Doc
    struct Doc: Codable {
        let id, ownerID: Int
        let title: String
        let size: Int
        let ext: String
        let date, type: Int
        let url: String
        let accessKey: String

        enum CodingKeys: String, CodingKey {
            case id
            case ownerID = "owner_id"
            case title, size, ext, date, type, url
            case accessKey = "access_key"
        }
    }

    // MARK: - Link
    struct Link: Codable {
        let url: String
        let title, linkDescription, buttonText, buttonAction: String
        let target: String
        let photo: Photo.Item
        let isFavorite: Bool

        enum CodingKeys: String, CodingKey {
            case url, title
            case linkDescription = "description"
            case buttonText = "button_text"
            case buttonAction = "button_action"
            case target, photo
            case isFavorite = "is_favorite"
        }
    }

    // MARK: - Likes
    struct Likes: Codable {
        let count, userLikes: Int
        let canLike, canPublish: Int?

        enum CodingKeys: String, CodingKey {
            case count
            case userLikes = "user_likes"
            case canLike = "can_like"
            case canPublish = "can_publish"
        }
    }

    // MARK: - OnlineInfo
    struct OnlineInfo: Codable {
        let visible: Bool
        let lastSeen: Int
        let isOnline, isMobile: Bool

        enum CodingKeys: String, CodingKey {
            case visible
            case lastSeen = "last_seen"
            case isOnline = "is_online"
            case isMobile = "is_mobile"
        }
    }

    // MARK: - PostSource
    struct PostSource: Codable {
        let type: String
    }

    // MARK: - Reposts
    struct Reposts: Codable {
        let count: Int
        let userReposted: Int?

        enum CodingKeys: String, CodingKey {
            case count
            case userReposted = "user_reposted"
        }
    }

    // MARK: - Size
    struct Size: Codable {
        let height: Int
        let url: String
        let type: String
        let width: Int
    }

    // MARK: - Views
    struct Views: Codable {
        let count: Int
    }
}

extension Json.Size {
  var ratio: CGFloat {
    CGFloat(width == 0 ? 0 : CGFloat(height) / CGFloat(width))
  }
}
