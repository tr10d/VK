//
//  News.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//
// swiftlint:disable identifier_name nesting

import Foundation
import RealmSwift

// MARK: - News
struct News: Codable {
    let response: Response?

    // MARK: - Response
    struct Response: Codable {
        let items: [Item]
        let profiles: [UsersJson.Item]
        let groups: [Groups.Item]
        let newOffset: String?
        let nextFrom: String?

        enum CodingKeys: String, CodingKey {
            case items, profiles, groups
            case newOffset = "new_offset"
            case nextFrom = "next_from"
        }
    }

    // MARK: - Item
    struct Item: Codable {
        let sourceID: Int
        let date: Int?
        let canDoubtCategory, canSetCategory: Bool?
        let postType, text: String?
        let markedAsAds: Int?
        let attachments: [Attachment]
        let postSource: PostSource?
        let comments: Comments?
        let likes: Likes?
        let reposts: Reposts?
        let views: Views?
        let isFavorite: Bool?
        let donut: Donut?
        let shortTextRate: Double?
        let carouselOffset, postID: Int?
        let type: String

        enum CodingKeys: String, CodingKey {
            case sourceID = "source_id"
            case date
            case canDoubtCategory = "can_doubt_category"
            case canSetCategory = "can_set_category"
            case postType = "post_type"
            case text
            case markedAsAds = "marked_as_ads"
            case attachments
            case postSource = "post_source"
            case comments, likes, reposts, views
            case isFavorite = "is_favorite"
            case donut
            case shortTextRate = "short_text_rate"
            case carouselOffset = "carousel_offset"
            case postID = "post_id"
            case type
        }
    }

    // MARK: - Profile
//    struct Profile: Codable {
//        let firstName: String
//        let id: Int
//        let lastName: String
//        let canAccessClosed, isClosed: Bool
//        let sex: Int?
//        let screenName: String?
//        let photo50, photo100: String?
//        let onlineInfo: OnlineInfo?
//        let online: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case firstName = "first_name"
//            case id
//            case lastName = "last_name"
//            case canAccessClosed = "can_access_closed"
//            case isClosed = "is_closed"
//            case sex
//            case screenName = "screen_name"
//            case photo50 = "photo_50"
//            case photo100 = "photo_100"
//            case onlineInfo = "online_info"
//            case online
//        }
//    }

//    // MARK: - Group
//    struct Group: Codable {
//        let id: Int
//        let name, screenName: String
//        let isClosed: Int
//        let type: String
//        let isAdmin, isMember, isAdvertiser: Int
//        let photo50, photo100, photo200: String
//
//        enum CodingKeys: String, CodingKey {
//            case id, name
//            case screenName = "screen_name"
//            case isClosed = "is_closed"
//            case type
//            case isAdmin = "is_admin"
//            case isMember = "is_member"
//            case isAdvertiser = "is_advertiser"
//            case photo50 = "photo_50"
//            case photo100 = "photo_100"
//            case photo200 = "photo_200"
//        }
//    }

    // MARK: - Attachment
    struct Attachment: Codable {
        let type: String
        let photo: Photo?
        let doc: Doc?
        let link: Link?
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
        let photo: Photo
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

    // MARK: - Photo
    struct Photo: Codable {
        let albumID, date, id, ownerID: Int
        let hasTags: Bool
        let sizes: [Size]
        let text: String
        let userID: Int
        let accessKey: String?

        enum CodingKeys: String, CodingKey {
            case albumID = "album_id"
            case date, id
            case ownerID = "owner_id"
            case hasTags = "has_tags"
            case sizes, text
            case userID = "user_id"
            case accessKey = "access_key"
        }
    }

    // MARK: - Size
    struct Size: Codable {
        let height: Int
        let url: String
        let type: String
        let width: Int
    }

    // MARK: - Comments
    struct Comments: Codable {
        let count, canPost: Int
        let groupsCanPost: Bool

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

    // MARK: - Likes
    struct Likes: Codable {
        let count, userLikes, canLike, canPublish: Int

        enum CodingKeys: String, CodingKey {
            case count
            case userLikes = "user_likes"
            case canLike = "can_like"
            case canPublish = "can_publish"
        }
    }

    // MARK: - PostSource
    struct PostSource: Codable {
        let type: String
    }

    // MARK: - Reposts
    struct Reposts: Codable {
        let count, userReposted: Int

        enum CodingKeys: String, CodingKey {
            case count
            case userReposted = "user_reposted"
        }
    }

    // MARK: - Views
    struct Views: Codable {
        let count: Int
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

}

extension News: RealmManagerDataProtocol {

    func getRealmObject() -> [Object] {
        var realmObjects = [RealmNews]()
        guard let response = self.response else { return realmObjects }
        response.items.forEach { realmObjects.append(RealmNews(news: $0)) }
        return realmObjects
    }

}
