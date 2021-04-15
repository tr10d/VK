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
      let attachments: [Attachment]?
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
      var group: Json.Groups.Item?

      enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
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

extension Json.News.Response {
  func configured() -> Json.News.Response {
    var newRespnse = self
    newRespnse.items = self.items
      .map {
        var newsUpdated = $0
        let identifire = abs(newsUpdated.sourceID)
        if newsUpdated.isUser {
          if let user = self.profiles.first(where: { $0.id == identifire }) {
            newsUpdated.user = user
          }
        } else {
          if let group = self.groups.first(where: { $0.id == identifire }) {
            newsUpdated.group = group
          }
        }
        return newsUpdated
      }
    return newRespnse
  }
}

extension Json.News.Item: Equatable {
  static func == (lhs: Json.News.Item, rhs: Json.News.Item) -> Bool {
    lhs.sourceID == rhs.sourceID && lhs.date == rhs.date && lhs.type == rhs.type
  }
}

extension Json.News.Item {
  var isUser: Bool {
    sourceID > 0
  }
  var newsImage: UIImage? {
    var url: String = ""

    if let photos = photos {
      debugPrint(photos)
    } else if let attachments = attachments, !attachments.isEmpty {
      if let element = attachments.first(where: { $0.type == "photo" }),
         let photo = element.photo {
        url = photo.urlForWidthScreen()
      }
    }
    return url.uiImage
  }
  var avatarImage: UIImage? {
    var url: String?
    if isUser {
      if let user = user {
        url = user.photo50
      }
    } else {
      if let group = group {
        url = group.photo50
      }
    }
    return url?.uiImage
  }
  var avatarName: String {
    var name: String?
    if isUser {
      if let user = user {
        name = user.description
      }
    } else {
      if let group = group {
        name = group.name
      }
    }
    return name ?? ""
  }

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
