//
//  NewsTableViewCellModel.swift
//  VK
//
//  Created by  Sergei on 19.05.2021.
//

import UIKit

struct NewsTableViewCellModel {
  let avatarName: String
  let avatarImage: UIImage?
  let newsImage: UIImage?
  let newsContent: String
  let newsDate: String
  let likesCount: String
  let commentsCount: String
  let repostsCount: String
  let viewsCount: String
  let isLikes: Bool
  let identifire: String
  let ratio: CGFloat?
}

class NewsTableViewCellModelBuilder {
  var avatarName: String = ""
  var avatarImage: UIImage?
  var newsImage: UIImage?
  var newsContent: String = ""
  var newsDate: String = ""
  var likesCount: String = ""
  var commentsCount: String = ""
  var repostsCount: String = ""
  var viewsCount: String = ""
  var isLikes: Bool = false
  var identifire: String = ""
  var ratio: CGFloat?

  init(identifire: String) {
    self.identifire = identifire
  }

  func build() -> NewsTableViewCellModel {
    NewsTableViewCellModel(
      avatarName: avatarName,
      avatarImage: avatarImage,
      newsImage: newsImage,
      newsContent: newsContent,
      newsDate: newsDate,
      likesCount: likesCount,
      commentsCount: commentsCount,
      repostsCount: repostsCount,
      viewsCount: viewsCount,
      isLikes: isLikes,
      identifire: identifire,
      ratio: ratio)
  }

  func addAvatar(avatarName: String, avatarImage: UIImage?) -> Self {
    self.avatarName = avatarName
    self.avatarImage = avatarImage
    return self
  }

  func addNews(newsContent: String, newsDate: String, newsImage: Json.Size?) -> Self {
    self.newsContent = newsContent
    self.newsDate = newsDate
    self.newsImage = newsImage?.url.uiImage
    self.ratio = newsImage?.ratio
    return self
  }

  func addCounts(likesCount: Int, commentsCount: Int, repostsCount: Int, viewsCount: Int) -> Self {
    self.likesCount = likesCount.description
    self.commentsCount = commentsCount.description
    self.repostsCount = repostsCount.description
    self.viewsCount = viewsCount.description
    return self
  }

  func addFlags(isLikes: Bool) -> Self {
    self.isLikes = isLikes
    return self
  }
}
