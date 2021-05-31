//
//  Factory.swift
//  VK
//
//  Created by  Sergei on 19.05.2021.
//

import Foundation

final class SimpleFactory {
  func newNewsTableViewCellModel(news: Json.News.Item) -> NewsTableViewCellModel {
    return NewsTableViewCellModelBuilder(identifire: news.identifire)
      .addAvatar(avatarName: news.avatarName, avatarImage: news.avatarImage)
      .addNews(newsContent: news.contentText, newsDate: news.dateFormatted, newsImage: news.newsImage)
      .addCounts(
        likesCount: news.likesCount,
        commentsCount: news.commentsCount,
        repostsCount: news.viewsCount,
        viewsCount: news.likesCount)
      .addFlags(isLikes: news.isLikes)
      .build()
  }
}
