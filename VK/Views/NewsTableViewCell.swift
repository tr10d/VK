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
  static let font = UIFont.systemFont(ofSize: 14)
  static let maxHeightText = CGFloat(200)

  struct CellSizes {
    let imageHeight, contentHeight, buttonHeight: CGFloat
    var heightForRowAt: CGFloat {
      60 + 20 + 6 + buttonHeight + contentHeight + imageHeight
    }

    internal init(imageHeight: CGFloat, contentHeight: CGFloat, buttonHeight: CGFloat) {
      self.imageHeight = imageHeight
      self.contentHeight = contentHeight
      self.buttonHeight = buttonHeight
//      self.full = 60 + 20 + 6 + buttonHeight + contentHeight + imageHeight
    }
  }

  static func cellSizes(news: Json.News.Item, width: CGFloat) -> CellSizes {
    var contentHeight: CGFloat = 0
    var buttonHeight: CGFloat = 0
    var imageHeight: CGFloat = 0

    if !news.contentText.isEmpty {
      let heightText = news.contentText.height(withConstrainedWidth: width, font: NewsTableViewCell.font)
      if heightText <= NewsTableViewCell.maxHeightText {
        contentHeight = heightText
      } else {
        contentHeight = NewsTableViewCell.maxHeightText
        buttonHeight = 30
      }
   }

    if let ratio = news.newsImage?.ratio {
      imageHeight = width * ratio
    }

    return CellSizes(imageHeight: imageHeight, contentHeight: contentHeight, buttonHeight: buttonHeight)
  }

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

  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  @IBOutlet weak var contentHeight: NSLayoutConstraint!
  @IBOutlet weak var buttonHeight: NSLayoutConstraint!

  @IBAction func buttonTouched(_ sender: UIButton) {

  }

//   avatar - 60
//   text - 200 ??
//   button - 30
//   image - 100 ??
//   likes - 20
//   placeholder - 6
  func configure(news: Json.News.Item) {
    newsUser.text = news.avatarName
    newsUserImg.image = news.avatarImage
    newsImages.image = news.newsImage?.url.uiImage

    newsContent.text = news.contentText
    newsDate.text = news.dateFormatted

    likesCount.text = news.likesCount.description
    commentsCount.text = news.commentsCount.description
    repostsCount.text = news.repostsCount.description
    viewsCount.text = news.viewsCount.description
    likes.setLikes(news.isLikes)

    let cellSizes = CachedData.shared.cachedValue(for: news.identifire) {
      NewsTableViewCell.cellSizes(news: news, width: frame.width)
    }
    contentHeight.constant = cellSizes.contentHeight
    buttonHeight.constant = cellSizes.buttonHeight
    imageHeight.constant = cellSizes.imageHeight

//    if newsContent.text.isEmpty {
//      contentHeight.constant = 1
//      buttonHeight.constant = 1
//    } else {
//      let heightText = newsContent.text.height(withConstrainedWidth: frame.width, font: NewsTableViewCell.font)
//      if heightText <= NewsTableViewCell.maxHeightText {
//        contentHeight.constant = heightText
//        buttonHeight.constant = 1
//      } else {
//        contentHeight.constant = NewsTableViewCell.maxHeightText
//        buttonHeight.constant = 30
//      }
//   }
//
//    if let ratio = news.newsImage?.ratio {
//      imageHeight.constant = frame.width * CGFloat(ratio)
//    } else {
//      imageHeight.constant = 1
//    }
  }
}
