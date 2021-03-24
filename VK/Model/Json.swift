//
//  Json.swift
//  VK
//
//  Created by  Sergei on 24.03.2021.
//
// swiftlint:disable identifier_name nesting line_length

import Foundation

struct Json {
    private let v = ""
}

// MARK: - Info

extension Json {

    struct Info: Codable {

        let response: Response

        // MARK: - Response
        struct Response: Codable {
            let country: String
        }

    }

}

// MARK: - News

extension Json {

    struct News: Codable {
        let response: Response?

        // MARK: - Response
        struct Response: Codable {
            let items: [Item]
            let profiles: [Users.Item]
//            let groups: [Groups.Item]
            let newOffset: String?
            let nextFrom: String

            enum CodingKeys: String, CodingKey {
                case items
                case profiles
//                case groups
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
//            let attachments: [Attachment]
//            let postSource: PostSource?
            let comments: Comments?
            let likes: Likes?
            let reposts: Reposts?
            let views: Views?
            let isFavorite: Bool?
//            let donut: Donut?
            let shortTextRate: Double?
//            let carouselOffset, postID: Int?
            let type: String

            enum CodingKeys: String, CodingKey {
                case sourceID = "source_id"
                case date
                case canDoubtCategory = "can_doubt_category"
                case canSetCategory = "can_set_category"
                case postType = "post_type"
                case text
                case markedAsAds = "marked_as_ads"
//                case attachments
//                case postSource = "post_source"
                case comments
                case likes
                case reposts
                case views
                case isFavorite = "is_favorite"
//                case donut
                case shortTextRate = "short_text_rate"
//                case carouselOffset = "carousel_offset"
//                case postID = "post_id"
                case type
            }
        }

    }

}

extension Json.News.Item {

    var isPhoto: Bool {
        type == API.FilterItems.photo.rawValue
    }

    var isPost: Bool {
        type == API.FilterItems.post.rawValue
    }

    var contentText: String {
        if isPost, let text = text {
            return text
        } else {
            return ""
        }
    }

    var isLikes: Bool {
        guard let likes = likes else {
            return false
        }
        return likes.userLikes == 1
    }
    
    var likesCount: Int {
        likes?.count ?? 0
    }
    
    var commentsCount: Int {
        comments?.count ?? 0
    }
    
    var repostsCount: Int {
        reposts?.count ?? 0
    }
    
    var viewsCount: Int {
        views?.count ?? 0
    }
}

// MARK: - Photo

extension Json {

    struct Photo: Codable {

        let response: Response?

        // MARK: - Response
        struct Response: Codable {
            let count: Int
            let items: [Item]
            let more: Int
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

// MARK: - Users

extension Json {

    struct Users: Codable {

        let response: Response?

        struct Response: Codable {
            let count: Int
            let items: [Item]
        }

        struct Item: Codable {
            let firstName: String
            let id: Int
            let lastName: String
            let canAccessClosed, isClosed: Bool?
            let sex: Int?
            let screenName: String?
            let photo50, photo100: String?
            let online: Int?

            enum CodingKeys: String, CodingKey {
                case firstName = "first_name"
                case id
                case lastName = "last_name"
                case canAccessClosed = "can_access_closed"
                case isClosed = "is_closed"
                case sex
                case screenName = "screen_name"
                case photo50 = "photo_50"
                case photo100 = "photo_100"
                case online
            }
        }
    }

}

extension Json.Users.Item {

    var description: String {
        "\(lastName) \(firstName)"
    }

}

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

// MARK: - Misc

extension Json {

    // MARK: - Attachment
    struct Attachment: Codable {
        let type: String
        let photo: Photo?
        let doc: Doc?
        let link: Link?
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
