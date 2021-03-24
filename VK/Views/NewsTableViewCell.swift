//
//  NewsTableViewCell.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
    static let identifier = "Cell"

    @IBOutlet private weak var newsUserImg: UIImageView!
    @IBOutlet private weak var newsUser: UILabel!
    @IBOutlet private weak var newsDate: UILabel!
    @IBOutlet private weak var newsContent: UITextView!
    @IBOutlet private weak var newsImages: UIImageView!

    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var likes: UIImageView!

    func configure(news: Json.News.Item) {
        newsContent.text = news.contentText
        likesCount.text = news.likesCount.description
        commentsCount.text = news.commentsCount.description
        repostsCount.text = news.repostsCount.description
        viewsCount.text = news.viewsCount.description
        likes.setLikes(news.isLikes)
  }

}
