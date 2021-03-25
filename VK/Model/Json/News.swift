//
//  News.swift
//  VK
//
//  Created by  Sergei on 25.03.2021.
//
// swiftlint:disable nesting

import Foundation
import RealmSwift

extension Json {

    struct News: Codable {
        let response: Response?

        // MARK: - Response
        struct Response: Codable {
            var items: [Item]
            let profiles: [Users.Item]
            let groups: [Groups.Item]
            let newOffset: String?
            let nextFrom: String?

            enum CodingKeys: String, CodingKey {
                case items
                case profiles
                case groups
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
            let photos: Json.Photo.Response?

//            let testItem: String? = nil
            var user: Json.Users.Item?

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
                case photos
            }
        }

    }

}

extension Json.News {

    mutating func configure() {
        guard var response = response else { return }
        for (index, news) in response.items.enumerated() {
            if let user = response.profiles.first(where: { $0.id == abs(news.sourceID) }) {
                response.items[index].user = user
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

    var dateFormatted: String {
        guard let date = date else {
            return ""
        }
        return date.date
    }

    var userDescription: String {
        guard let user = user else {
            return ""
        }
        return user.description
    }
}
