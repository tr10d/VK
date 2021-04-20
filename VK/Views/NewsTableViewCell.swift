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

  @IBOutlet weak var button: UIButton!

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
    configureContentHeight()
  }

  var contentHeightMin: CGFloat = 0
  var contentHeightMax: CGFloat = 0
}

// MARK: - Configuration

extension NewsTableViewCell {
  private func configureContentHeight() {
    if contentHeight.constant <= contentHeightMin {
      button.setTitle("Скрыть", for: .normal)
      contentHeight.constant = contentHeightMax
    } else {
      button.setTitle("Показать всё", for: .normal)
      contentHeight.constant = contentHeightMin
    }
  }

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

    contentHeightMin = cellSizes.contentHeightMin
    contentHeightMax = cellSizes.contentHeightMax

    configureContentHeight()

    buttonHeight.constant = cellSizes.buttonHeight
    imageHeight.constant = cellSizes.imageHeight
  }
}

// MARK: - CellSizes

extension NewsTableViewCell {

  //   avatar - 60
  //   text - 200 ??
  //   button - 30 ??
  //   image - 100 ??
  //   likes - 20
  //   placeholder - 6
  struct CellSizes {
    let imageHeight: CGFloat
    let contentHeightMin, contentHeightMax: CGFloat
    let buttonHeight: CGFloat

    var heightForRowAt: CGFloat {
      60 + 20 + 6 + buttonHeight + contentHeightMin + imageHeight
    }

    internal init(imageHeight: CGFloat, contentHeightMin: CGFloat, contentHeightMax: CGFloat, buttonHeight: CGFloat) {
      self.imageHeight = imageHeight
      self.contentHeightMin = contentHeightMin
      self.contentHeightMax = contentHeightMax
     self.buttonHeight = buttonHeight
    }
  }

  static func cellSizes(news: Json.News.Item, width: CGFloat) -> CellSizes {
    var contentHeightMin: CGFloat = 0
    var contentHeightMax: CGFloat = 0
    var buttonHeight: CGFloat = 0
    var imageHeight: CGFloat = 0

    if !news.contentText.isEmpty {
      contentHeightMax = news.contentText.height(withConstrainedWidth: width, font: NewsTableViewCell.font)
      if contentHeightMax <= NewsTableViewCell.maxHeightText {
        contentHeightMin = contentHeightMax
      } else {
        contentHeightMin = NewsTableViewCell.maxHeightText
        buttonHeight = 30
      }
    }

    if let ratio = news.newsImage?.ratio {
      imageHeight = width * ratio
    }

    return CellSizes(
      imageHeight: imageHeight,
      contentHeightMin: contentHeightMin,
      contentHeightMax: contentHeightMax,
      buttonHeight: buttonHeight
    )
  }
}
